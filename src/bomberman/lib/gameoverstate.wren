import "../../lib/input"
import "./global"

class GameOverState {
	construct new(scores, winner, numberOfPlayers) {
		_scores = scores
		_winner = winner
		_numberOfPlayers = numberOfPlayers
		if (_winner != -1) {
			Global.incWin(_winner)
		}
		_btnDown = false
	}

	TIC(game) {
		TIC.cls()
		
		if (Input.any.action) {
			_btnDown = true
		}
		if (_btnDown && !Input.any.action) {
			game.state = PlayState.new(_numberOfPlayers)
		}

		if (_winner == -1) {
			TIC.print("draw", 0, 0, 14)
			return
		}

		TIC.print("player " + (_winner + 1).toString + " won", 0, 0, 14)
		TIC.print("wins", 0, 8, 14)
		for (i in 0..._numberOfPlayers) {
			TIC.print("player %(i+1): %(Global.wins[i])", 8, 8 * (i + 2), 14)
		}
	}
}