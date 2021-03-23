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
}

var SPR = {
  "SMALL_BOMB": 22,
  "BOMB_OUTLINE": 38,
  "UI_BOMB_COUNT": 57,
  "UI_BLAST_POWER": 59
}