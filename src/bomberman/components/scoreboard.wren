class ScoreBoard {
 construct new() {
  _score = [0, 0, 0, 0]
 }

 count { 4 }
 [i] { _score[i] }

 inc(playerNumber) {
  _score[playerNumber] = _score[playerNumber] + 1
 }
}