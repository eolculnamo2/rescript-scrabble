type boardState = {
  players: array<Player.t>,
  turn: Player.playerId,
  tiles: array<Scrabble.Tile.t>,
  bag: array<Scrabble.Letter.t>,
  errorMsg: option<string>,
  debug: bool,
  selectedLetter: option<Scrabble.Letter.t>,
}
