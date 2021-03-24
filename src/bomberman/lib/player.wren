import "../../lib/vec2d"
import "../../lib/numberutils"
import "../../lib/entity"
import "./palette"
import "./sprites"

class Player is Entity {
	construct new(number, position) {
		super(position, Vec2d.tile)
		_number = number
		_targetPosition = position
		_previousPosition = position
		sprite = Sprites.player
		_bombCount = 1
		_bombPower = 1
		_bombCountMax = 1
		_framesPerSprite = 5
		_animationDirection = 1
		_animationFrameCount = 0
		_animate = false
		_rotate = 0
		_distanceMoved = 0
	}

	number { _number }

	targetPosition { _targetPosition }
	targetPosition=(v) { _targetPosition = v }

	previousPosition { _previousPosition }
	previousPosition=(v) { _previousPosition = v }

	bombCount { _bombCount }
	bombCount=(v) { _bombCount = v }

	bombCountMax { _bombCountMax }
	bombCountMax=(v) { _bombCountMax = v }

	bombPower { _bombPower }
	bombPower=(v) { _bombPower = v }

	animate { _animate }
	animate=(v) { _animate = v }

	rotate { _rotate }
	rotate=(v) { _rotate = v }

	distanceMoved { _distanceMoved }
	distanceMoved=(v) { _distanceMoved = v }

	TIC() {
		_bombCountMax = NumberUtils.max(_bombCount, _bombCountMax)
		if (_animate) {
			_animationFrameCount = _animationFrameCount + 1
			if (_animationFrameCount == _framesPerSprite) {
				_animationFrameCount = 0
				sprite = sprite + _animationDirection
				if (TIC.fget(sprite, 1) || TIC.fget(sprite, 2)) {
					_animationDirection = _animationDirection * -1
				}
			}
		}
		Palette.updateForPlayer(number)
		TIC.spr(sprite, position.x, position.y, 0, 1, 0, rotate, size.x / 8, size.y / 8)
		Palette.reset()
	}
}