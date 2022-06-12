type state = {
  players: array<Player.t>,
  turn: Player.playerId,
  tiles: array<Scrabble.Tile.t>,
  bag: array<Scrabble.Letter.t>,
  errorMsg: option<string>,
  debug: bool,
}

let buildInitialState = () => {
  let (bag, bagErrorMsg) = switch Scrabble.Letter.buildBag() {
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
  ]->Player.assignInitialLettersToPlayer(bag)

  let (playerId, playerErrorMsg) = switch players->Belt.Array.get(0) {
  | Some(p) => (p.playerId, None)
  | None => (-1, Some("Must have at least one player to play"))
  }

  {
    players: players,
    turn: playerId,
    tiles: Boot.generateTiles(),
    bag: updatedBag,
    errorMsg: if bagErrorMsg->Belt.Option.isSome {
      bagErrorMsg
    } else if playerErrorMsg->Belt.Option.isSome {
      playerErrorMsg
    } else {
      None
    },
    debug: false,
  }
}

let initialState = buildInitialState()

type actions = PlaceTile

let reducer = (state, action) => {
  switch action {
  | PlaceTile => state
  }
}

@react.component
let make = () => {
  let (state, dispatch) = React.useReducer(reducer, initialState)
  Js.log(state)

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
          <Tile_C key={tile.placementIndex->Belt.Int.toString} details={tile} debug={state.debug} />
        })
        ->React.array}
      </div>
      <MyLetters_C
        letters={(state.players->Js.Array2.find(player => player.isMe)->Belt.Option.getExn).letters}
      />
    </div>
  </div>
}
