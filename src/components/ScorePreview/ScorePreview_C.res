@react.component
let make = (~scorePreview) => {
  <div style={ReactDOM.Style.make(~display="flex", ~justifyContent="flex-end", ())}>
    <div
      style={ReactDOM.Style.make(
        ~display="flex",
        ~justifyContent="flex-end",
        ~alignItems="center",
        (),
      )}>
      <h3 style={ReactDOM.Style.make(~margin="0 1rem 0 0", ())}>
        {"Score Preview"->React.string}
      </h3>
      <div> <strong> {scorePreview->Belt.Int.toString->React.string} </strong> </div>
    </div>
  </div>
}
