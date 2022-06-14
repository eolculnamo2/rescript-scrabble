type direction = Horizontal | Vertical
type edge = Left | Right | NotEdge

let getPlacementFromTiles = (tiles: array<Scrabble.Tile.t>) =>
  tiles->Belt.Array.map(tile => tile.placementIndex)

let getEdgeTypeIfEdge = placement => {
  // placement pattern is 15, 30, 45 for left
  // 14, 29, 44 for right
  if mod(Scrabble.Board.tilesPerRow, placement) == 0 {
    Left
  } else if mod(Scrabble.Board.tilesPerRow, placement + 1) == 0 {
    Right
  } else {
    NotEdge
  }
}

let isHorizontal = ((placement1, placement2)) => {
  let placement1Edge = placement1->getEdgeTypeIfEdge

  let placement2WithOffsetRight = placement2 - 1
  let placement2WithOffsetLeft = placement2 + 1

  if placement1Edge == Left {
    placement1 == placement2WithOffsetRight
  } else if placement1Edge == Right {
    placement1 == placement2WithOffsetLeft
  } else {
    placement1 == placement2WithOffsetLeft || placement1 == placement2WithOffsetRight
  }
}

// let isVertical = ((placement1, placement2)) => {

// }

// infers direction from first two tiles
let determineDirection = (tiles): result<direction, string> => {
  let indexes = tiles->getPlacementFromTiles

  // length is validated in length section
  let placement1 = indexes->Belt.Array.get(0)->Belt.Option.getExn
  let placement2 = indexes->Belt.Array.get(1)->Belt.Option.getExn

  if isHorizontal((placement1, placement2)) {
    Ok(Horizontal)
  } else {
    Error("Placement is neither vertical or horizontal")
  }
}

let validateDirection = tiles => {
  // 1 determine if its a row or column
  switch tiles->determineDirection {
  | Ok(_) => true
  | Error(e) => {
      Js.Console.error(e)
      false
    }
  }
  // 2 validate based on direction
}

// handle cases where its always true first
// then handle failures and last return true
let make = tiles => {
  if tiles->Belt.Array.length < 3 {
    Ok(true)
  } else if tiles->validateDirection == false {
    Error("Invalid direction")
  } else {
    Ok(true)
  }
}
