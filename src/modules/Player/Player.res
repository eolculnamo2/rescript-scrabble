type playerId = int
type t = {
  name: string,
  playerId: playerId,
  score: int,
  place: int,
  isMe: bool,
  letters: array<Scrabble.Letter.t>,
}

let assignInitialLettersToPlayer = (players: array<t>, bag: array<Scrabble.Letter.t>) => {
  let bagRef = ref(bag)
  let updatedPlayers = players->Belt.Array.map(player => {
    let (letters, newBag) = Scrabble.Letter.pullManyFromBag(bagRef.contents, 7)
    bagRef := newBag
    {
      ...player,
      letters: letters,
    }
  })
  (updatedPlayers, bagRef.contents)
}
