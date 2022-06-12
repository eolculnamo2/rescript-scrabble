@react.component
let make = () => {
  <div
    style={ReactDOM.Style.make(
      ~height="100vh",
      ~width="100vw",
      ~display="grid",
      ~placeItems="center",
      (),
    )}>
    <Board_C />
  </div>
}
