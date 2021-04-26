import "../inputs/buttons"
import "./scene"

class GameOverScene is Scene {
 construct new(game, numberOfPlayers, winner) {
  super(game)
  _numberOfPlayers = numberOfPlayers
  _winner = winner
  if (winner != -1) {
   game.scoreBoard.inc(winner)
  }
 }

 TIC() {
		TIC.cls()

  if (game.gamepad.btnr(Buttons.P1A)) {
   game.scene = PlayScene.new(game, _numberOfPlayers)
  }
		
		if (_winner == -1) {
			TIC.print("draw", 0, 0, 14)
		} else {
			TIC.print("player " + (_winner + 1).toString + " won", 0, 0, 14)
		}

		TIC.print("wins", 0, 8, 14)
		for (i in 0..._numberOfPlayers) {
			TIC.print("player %(i+1): %(game.scoreBoard[i])", 8, 8 * (i + 2), 14)
		}
 }
}