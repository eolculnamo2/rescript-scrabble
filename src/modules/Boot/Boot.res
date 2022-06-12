let generateTiles = () => {
  let tiles: array<Scrabble.Tile.t> = []
  for i in 0 to Scrabble.Board.totalTiles - 1 {
    let newTile: Scrabble.Tile.t = {
      kind: Scrabble.Board.resolveKindByIndex(i),
      letter: None,
      placementIndex: i,
    }
    let _ = tiles->Js.Array2.push(newTile)
  }
  tiles
}
