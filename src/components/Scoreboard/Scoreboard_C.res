@react.component
let make = (~players: array<Player.t>, ~turn: Player.playerId) => {
  <div
    style={ReactDOM.Style.make(
      ~border="1px solid brown",
      ~background="tan",
      ~padding="1rem",
      ~marginRight="1rem",
      (),
    )}>
    <h3> {"Score"->React.string} </h3>
    {players
    ->Belt.SortArray.stableSortBy((a, b) => a.score < b.score ? 1 : -1)
    ->Belt.Array.map(player => {
      <p
        key={player.playerId->Belt.Int.toString}
        style={ReactDOM.Style.make(~color={turn == player.playerId ? "green" : "black"}, ())}>
        <strong> {`${player.name} ${player.score->Belt.Int.toString}`->React.string} </strong>
      </p>
    })
    ->React.array}
  </div>
}
