@module("./Board_C.module.css") external styles: {..} = "default"

let initialState = BoardInit.buildInitialState()

type actions = TileClicked(Scrabble.Letter.t) | HandleTileClick(Scrabble.Tile.t)

let reducer = (state: BoardTypes.boardState, action) => {
  switch action {
  | TileClicked(letter) => {
      ...state,
      selectedLetter: switch state.selectedLetter {
      | Some(l) => l.id == letter.id ? None : Some(letter)
      | None => Some(letter)
      },
    }
  | HandleTileClick(tile) => {
      let (updatedTiles, tileUpdated) = switch state.selectedLetter {
      | Some(l) => state.tiles->Scrabble.Tile.handleTileUpdate(tile.placementIndex, l)
      | None => (state.tiles, false)
      }

      {
        ...state,
        selectedLetter: None,
        players: switch (state.selectedLetter, tileUpdated) {
        | (_, false) => state.players
        | (Some(l), true) => state.players->Player.removeLetterFromMyPlayer(l.id)
        | (None, true) => state.players
        },
        tiles: updatedTiles,
      }
    }
  }
}

@react.component
let make = () => {
  let (state, dispatch) = React.useReducer(reducer, initialState)

  state.debug ? Js.log(state) : ()

  <div>
    <ScorePreview_C scorePreview={state.tiles->Score.calculateScorePreview} />
    <div style={ReactDOM.Style.make(~display="flex", ())}>
      <Scoreboard_C players={state.players} turn={state.turn} />
      <div>
        {switch state.errorMsg {
        | Some(m) => <p style={ReactDOM.Style.make(~color="red", ())}> {m->React.string} </p>
        | None => <> </>
        }}
        <div
          style={ReactDOM.Style.make(
            ~display="grid",
            ~gridTemplateColumns="repeat(" ++
            Scrabble.Board.tilesPerRow->Belt.Int.toString ++
            ", " ++
            Scrabble.Tile.tileWidthPx ++ ")",
            (),
          )}>
          {state.tiles
          ->Belt.Array.map(tile => {
            <Tile_C
              handleClick={tile => dispatch(HandleTileClick(tile))}
              key={tile.placementIndex->Belt.Int.toString}
              details={tile}
              debug={state.debug}
            />
          })
          ->React.array}
        </div>
        <div style={ReactDOM.Style.make(~display="flex", ~alignItems="center", ())}>
          <MyLetters_C
            selectedLetter={state.selectedLetter}
            handleTileClick={letter => dispatch(TileClicked(letter))}
            letters={(
              state.players->Js.Array2.find(player => player.isMe)->Belt.Option.getExn
            ).letters}
          />
          <button className={styles["actionButton"]}> {"Pass"->React.string} </button>
          <button className={styles["actionButton"]}> {"Play"->React.string} </button>
        </div>
      </div>
    </div>
  </div>
}
