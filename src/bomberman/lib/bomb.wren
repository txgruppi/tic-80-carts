import "../../lib/vec2d"
import "../../lib/entity"
import "./sprites"

class Bomb is Entity {
	construct new(position, power, playerNumber) {
		super(position, Vec2d.tile)
		sprite = Sprites.smallBomb
		_power = power
		_playerNumber = playerNumber
		framesToLive = 110
		_framesForSecondStage = 55
	}

	power { _power }
	playerNumber { _playerNumber }
	framesForSecondStage { _framesForSecondStage }

	TIC() {
		if (framesToLive % 30 == 0) {
			sprite = sprite == Sprites.smallBomb ? Sprites.bigBomb : Sprites.smallBomb
		}
		TIC.spr(sprite, position.x, position.y, 0, 1, false, 0, size.x / 8, size.y / 8)
	}
}