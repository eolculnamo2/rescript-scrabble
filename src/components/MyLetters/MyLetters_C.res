@react.component
let make = (
  ~letters: array<Scrabble.Letter.t>,
  ~handleTileClick: Scrabble.Letter.t => unit,
  ~selectedLetter: option<Scrabble.Letter.t>,
) => {
  <div
    style={ReactDOM.Style.make(
      ~display="flex",
      ~padding=".5rem",
      ~margin="1rem",
      ~background="brown",
      ~width="350px",
      (),
    )}>
    {letters
    ->Belt.Array.mapWithIndex((i, letter) =>
      <div
        onClick={_ => handleTileClick(letter)}
        style={ReactDOM.Style.make(
          ~height={Scrabble.Tile.tileWidthPx},
          ~width={Scrabble.Tile.tileWidthPx},
          ~fontSize="1.25rem",
          ~textAlign="center",
          ~background="tan",
          ~border={
            letter->Scrabble.Letter.isLetterSelected(selectedLetter)
              ? "4px solid yellow"
              : "2px solid brown"
          },
          ~display="grid",
          ~placeItems="center",
          (),
        )}
        key={i->Belt.Int.toString}>
        <div> {letter->Scrabble.Letter.getDisplayLetter->React.string} </div>
        <div style={ReactDOM.Style.make(~fontSize=".875rem", ())}>
          {letter.score->Belt.Int.toString->React.string}
        </div>
      </div>
    )
    ->React.array}
  </div>
}
