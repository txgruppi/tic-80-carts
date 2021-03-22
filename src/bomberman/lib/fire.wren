import "../../lib/vec2d"
import "../../lib/entity"

class Fire is Entity {
	construct new(position) {
		super(position, Vec2d.tile)
		sprite = 40
		_spriteCount = 4
		framesToLive = 30
		_framesPerSprite = framesToLive / _spriteCount
		_tick = 0
	}

	TIC() {
		TIC.spr(sprite + (_tick / _framesPerSprite).floor, position.x, position.y, 0, 1, false, 0, size.x / 8, size.y / 8)
		_tick = _tick + 1
	}
}