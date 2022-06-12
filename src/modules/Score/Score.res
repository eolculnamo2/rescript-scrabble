let calculateScorePreview = (tiles: array<Scrabble.Tile.t>) => {
  tiles->Belt.Array.reduce(0, (agg, cur) => {
    if cur.status != Scrabble.Tile.Preview {
      agg
    } else {
      switch cur.letter {
      | Some(l) => l.score + agg
      | None => agg
      }
    }
  })
}
