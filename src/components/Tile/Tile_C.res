@react.component
let make = (~details: Scrabble.Tile.t, ~debug, ~handleClick) => {
  <div
    onClick={_ => handleClick(details)}
    style={ReactDOM.Style.make(
      ~width={Scrabble.Tile.tileWidthPx},
      ~height={Scrabble.Tile.tileWidthPx},
      ~background=Scrabble.Tile.getBackground(details),
      ~border="1px solid #333",
      (),
    )}>
    {switch details.letter {
    | Some(l) => l->Scrabble.Letter.getDisplayLetter
    | None => ""
    }->React.string}
    {switch debug {
    | true => details.placementIndex->Belt.Int.toString
    | false => ""
    }->React.string}
  </div>
}
