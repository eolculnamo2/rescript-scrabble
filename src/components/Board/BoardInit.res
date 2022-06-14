let generateTiles = () => {
  let tiles: array<Scrabble.Tile.t> = []
  for i in 0 to Scrabble.Board.totalTiles - 1 {
    let newTile: Scrabble.Tile.t = {
      kind: Scrabble.Board.resolveKindByIndex(i),
      letter: None,
      placementIndex: i,
      status: Scrabble.Tile.Blank,
    }
    let _ = tiles->Js.Array2.push(newTile)
  }
  tiles
}

let buildInitialState = (): BoardTypes.boardState => {
  let (initialBag, bagErrorMsg) = switch Scrabble.Letter.buildBag() {
  | Ok(b) => (b, None)
  | Error(msg) => ([], Some(msg))
  }

  // is this brittle with bag?
  let (players, updatedBag) = [
    {
      name: "test 1",
      playerId: 1,
      score: 0,
      place: 1,
      isMe: true,
      letters: [],
    },
    {
      name: "test 2",
      playerId: 2,
      score: 0,
      place: 1,
      isMe: false,
      letters: [],
    },
  ]->Player.assignInitialLettersToPlayer(initialBag)

  let (playerId, playerErrorMsg) = switch players->Belt.Array.get(0) {
  | Some(p) => (p.playerId, None)
  | None => (-1, Some("Must have at least one player to play"))
  }

  {
    players: players,
    turn: playerId,
    tiles: generateTiles(),
    bag: updatedBag,
    errorMsg: if bagErrorMsg->Belt.Option.isSome {
      bagErrorMsg
    } else if playerErrorMsg->Belt.Option.isSome {
      playerErrorMsg
    } else {
      None
    },
    debug: true,
    selectedLetter: None,
  }
}
