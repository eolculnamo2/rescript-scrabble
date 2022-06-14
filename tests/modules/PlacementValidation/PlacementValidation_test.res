open Test

let createTile = (): Scrabble.Tile.t => {
  {
    kind: Scrabble.Tile.Normal,
    letter: None,
    placementIndex: 0,
    status: Scrabble.Tile.Blank,
  }
}

test("PlacementValidation make", () => {
  let tiles1 = [createTile(), createTile()]
  let result1 = PlacementValidation.make(tiles1)

  assertion(
    ~message="Returns Ok(true) when < 3 tiles",
    ~operator="make",
    (a, b) => a == b,
    result1,
    Ok(true),
  )

  let tiles2 = [createTile()]
  let result2 = PlacementValidation.make(tiles2)
  assertion(
    ~message="Returns Ok(true) when 1 tiles",
    ~operator="make",
    (a, b) => a == b,
    result2,
    Ok(true),
  )

  let tiles3 = []
  let result3 = PlacementValidation.make(tiles3)
  assertion(
    ~message="Returns Ok(true) when 0 tiles",
    ~operator="make",
    (a, b) => a == b,
    result3,
    Ok(true),
  )
})
