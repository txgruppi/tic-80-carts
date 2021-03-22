import "../../lib/input"

class GameOverState {
	construct new(scores, winner) {
		_scores = scores
		_winner = winner
	}

	TIC(game) {
		TIC.cls()
		
		if (Input.any.justAction) {
			game.state = MenuState.new()
		}

		if (_winner == -1) {
			TIC.print("draw", 0, 0, 14)
			return
		}
		TIC.print("player " + (_winner + 1).toString + " won", 0, 0, 14)
	}
}