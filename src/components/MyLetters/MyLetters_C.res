@react.component
let make = (~letters: array<Scrabble.Letter.t>) => {
  <div
    style={ReactDOM.Style.make(
      ~display="flex",
      ~padding=".5rem",
      ~margin="1rem",
      ~background="brown",
      (),
    )}>
    {letters
    ->Belt.Array.mapWithIndex((i, letter) =>
      <div
        style={ReactDOM.Style.make(
          ~height={Scrabble.Tile.tileWidthPx},
          ~width={Scrabble.Tile.tileWidthPx},
          ~fontSize="1.25rem",
          ~textAlign="center",
          ~background="tan",
          ~border="2px solid brown",
          ~display="grid",
          ~placeItems="center",
          (),
        )}
        key={i->Belt.Int.toString}>
        <div> {letter.value->Js.String.toUpperCase->React.string} </div>
        <div style={ReactDOM.Style.make(~fontSize=".875rem", ())}>
          {letter.score->Belt.Int.toString->React.string}
        </div>
      </div>
    )
    ->React.array}
  </div>
}
