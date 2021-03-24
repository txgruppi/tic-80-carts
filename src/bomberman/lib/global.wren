class Global {
 static resetWins() {
  __wins = [0, 0, 0, 0]
 }

 static incWin(playerNumber) {
  if (__wins == null) {
   resetWins()
  }
  __wins[playerNumber] = __wins[playerNumber]  + 1
 }

 static wins {
  return __wins
 }
}