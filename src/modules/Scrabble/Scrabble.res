// https://scrabble.hasbro.com/en-us/faq#:~:text=Scrabble%20tile%20letter%20distribution%20is,of%20all%20the%20Scrabble%20tiles%3F
module Letter = {
  exception Tile_Unscored(string)
  type t = {score: int, value: string, id: string}
  type pointsTable = {
    zero: array<string>,
    one: array<string>,
    two: array<string>,
    three: array<string>,
    four: array<string>,
    five: array<string>,
    eight: array<string>,
    ten: array<string>,
  }
  let pointsTable = {
    zero: ["blank"],
    one: ["a", "e", "i", "o", "u", "l", "n", "s", "t", "r"],
    two: ["d", "g"],
    three: ["b", "c", "m", "p"],
    four: ["f", "h", "v", "w", "y"],
    five: ["k"],
    eight: ["j", "x"],
    ten: ["q", "z"],
  }

  // could include points in this instead of points table
  // but keep it separate to make it easier to think about
  // even with the computational cost
  type distributionDescription = {
    letter: string,
    frequency: int,
  }
  let ddFactory = (letter: string, freq: int): distributionDescription => {
    letter: letter,
    frequency: freq,
  }
  let distributionList: array<distributionDescription> = [
    ddFactory("a", 9),
    ddFactory("b", 2),
    ddFactory("c", 2),
    ddFactory("d", 4),
    ddFactory("e", 12),
    ddFactory("f", 2),
    ddFactory("g", 3),
    ddFactory("h", 2),
    ddFactory("i", 9),
    ddFactory("j", 1),
    ddFactory("k", 1),
    ddFactory("l", 4),
    ddFactory("m", 2),
    ddFactory("n", 6),
    ddFactory("o", 8),
    ddFactory("p", 2),
    ddFactory("q", 1),
    ddFactory("r", 6),
    ddFactory("s", 4),
    ddFactory("t", 6),
    ddFactory("u", 4),
    ddFactory("v", 2),
    ddFactory("w", 2),
    ddFactory("x", 1),
    ddFactory("y", 2),
    ddFactory("z", 1),
    ddFactory("blank", 2),
  ]

  let calculateScore = (letter: string): result<int, string> => {
    let isIncluded = Js.Array.includes(letter)
    if pointsTable.one->isIncluded {
      Ok(1)
    } else if pointsTable.two->isIncluded {
      Ok(2)
    } else if pointsTable.three->isIncluded {
      Ok(3)
    } else if pointsTable.four->isIncluded {
      Ok(4)
    } else if pointsTable.five->isIncluded {
      Ok(5)
    } else if pointsTable.eight->isIncluded {
      Ok(8)
    } else if pointsTable.ten->isIncluded {
      Ok(10)
    } else if pointsTable.zero->isIncluded {
      Ok(0)
    } else {
      Error("Could not assign a point value to letter: " ++ letter)
    }
  }

  let buildBag = (): result<array<t>, string> => {
    let bag: array<t> = []
    try {
      for i in 0 to distributionList->Belt.Array.length - 1 {
        let {letter, frequency} = distributionList->Belt.Array.get(i)->Belt.Option.getExn
        let score = switch calculateScore(letter) {
        | Ok(n) => n
        | Error(err) => raise(Tile_Unscored(err))
        }
        for j in 1 to frequency {
          let _ = bag->Js.Array2.push({
            score: score,
            value: letter,
            id: (i + j)->Belt.Int.toString ++ letter,
          })
        }
      }
      Ok(bag->Belt.Array.shuffle)
    } catch {
    | Tile_Unscored(err) => Error(err)
    | _ => Error("An unknown error occured building the tile bag")
    }
  }
  let randomlyPullFromBag = (lettersInBag: array<t>) => {
    let randomFloat = (lettersInBag->Belt.Array.length - 1)->Belt.Int.toFloat *. Js.Math.random()
    let randomIndex = randomFloat->Belt.Float.toInt
    (lettersInBag[randomIndex], lettersInBag->Js.Array2.filteri((_, i) => i != randomIndex))
  }

  let pullManyFromBag = (lettersInBag: array<t>, pullAmount: int) => {
    let lettersPulled: array<t> = []
    let arrRef = ref(lettersInBag)
    for _ in 1 to pullAmount {
      let (pulledLetter, newArr) = randomlyPullFromBag(arrRef.contents)
      arrRef := newArr
      let _ = lettersPulled->Js.Array2.push(pulledLetter)
    }
    (lettersPulled, arrRef.contents)
  }

  let isLetterSelected = (letter: t, selectedLetter: option<t>) => {
    switch selectedLetter {
    | Some(l) => l.id == letter.id
    | None => false
    }
  }

  let getDisplayLetter = (letter: t) => {
    let modifiedIfBlank = letter.value === "blank" ? "" : letter.value
    modifiedIfBlank->Js.String.toUpperCase
  }
}

module Tile = {
  type status = Blank | Preview | Committed
  type kind = Normal | StartTile | DoubleWord | TripleWord | DoubleLetter | TripleLetter
  type t = {kind: kind, letter: option<Letter.t>, placementIndex: int, status: status}

  let tileWidth = 40
  let tileWidthPx = tileWidth->Belt.Int.toString ++ "px"

  let getBackground = (tile: t) => {
    if tile.letter->Belt.Option.isSome {
      "tan"
    } else {
      switch tile.kind {
      | Normal => "tan"
      | StartTile => "red"
      | DoubleWord => "pink"
      | TripleWord => "darkred"
      | DoubleLetter => "lightblue"
      | TripleLetter => "blue"
      }
    }
  }

  let handleTileUpdate = (tiles: array<t>, placementIndex, letter: Letter.t) => {
    let didUpdate = ref(false)
    let updatedTiles = tiles->Belt.Array.map(existingTile => {
      if existingTile.placementIndex != placementIndex {
        existingTile
      } else {
        switch existingTile.letter {
        | Some(_) => existingTile
        | None => {
            didUpdate := true
            {
              ...existingTile,
              letter: Some(letter),
              status: Preview,
            }
          }
        }
      }
    })
    (updatedTiles, didUpdate.contents)
  }
}

module Board = {
  let tilesPerRow = 15
  let totalRows = 15
  let totalTiles = tilesPerRow * totalRows

  let startInt = totalTiles / 2
  let doubleWordIndexes: array<int> = [
    16,
    32,
    48,
    64,
    28,
    42,
    56,
    70,
    208,
    192,
    176,
    160,
    196,
    182,
    168,
    154,
  ]
  let tripleWordIndexes: array<int> = [0, 7, 14, 105, 119, 210, 217, 224]
  let doubleLetterIndexes: array<int> = [
    96,
    98,
    128,
    126,
    3,
    11,
    59,
    179,
    221,
    213,
    165,
    45,
    36,
    52,
    38,
    102,
    116,
    132,
    186,
    172,
    188,
    92,
    108,
    122,
  ]
  let tripleLetterIndexes: array<int> = [80, 84, 144, 140, 20, 24, 88, 148, 204, 200, 136, 76]

  let resolveKindByIndex = (placementIndex: int) => {
    if startInt == placementIndex {
      Tile.StartTile
    } else if doubleWordIndexes->Js.Array2.includes(placementIndex) {
      Tile.DoubleWord
    } else if tripleWordIndexes->Js.Array2.includes(placementIndex) {
      Tile.TripleWord
    } else if doubleLetterIndexes->Js.Array2.includes(placementIndex) {
      Tile.DoubleLetter
    } else if tripleLetterIndexes->Js.Array2.includes(placementIndex) {
      Tile.TripleLetter
    } else {
      Tile.Normal
    }
  }
}
