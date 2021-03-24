import "../../lib/input"
import "./global"

class MenuState {
	construct new() {
		_index = 0
		_actionDown = null
		Global.resetWins()
	}

	handleInput(game) {
		if (_actionDown == false) {
			game.state = PlayState.new(
				_index == 0 ? 2 : 4
			)
		}

		if (Input.any.justAction) {
			_actionDown = true
		}

		if (_actionDown == true) {
			_actionDown = Input.any.action
			return
		}

		var dy = 0
		if (Input.any.justUp) dy = dy - 1
		if (Input.any.justDown) dy = dy + 1
		_index = _index + dy
		if (_index < 0) {
			_index = 2
		} else if (_index > 1) {
			_index = 0
		}
	}

	TIC(game) {
		handleInput(game)

		TIC.cls()
		TIC.print(" 2 players", 0, 0, 14)
		TIC.print(" 4 players", 0, 8, 14)
		TIC.print(">", 0, 8*_index, 14)
	}
}