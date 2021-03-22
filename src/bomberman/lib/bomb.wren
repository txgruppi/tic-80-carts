import "../../lib/vec2d"
import "../../lib/entity"

class Bomb is Entity {
	construct new(position, power, playerNumber) {
		super(position, Vec2d.tile)
		sprite = 22
		_power = power
		_playerNumber = playerNumber
		framesToLive = 110
		_framesForSecondStage = 55
	}

	power { _power }
	playerNumber { _playerNumber }
	framesForSecondStage { _framesForSecondStage }

	TIC() {
		TIC.spr(sprite, position.x, position.y, 0, 1, false, 0, size.x / 8, size.y / 8)
	}
}