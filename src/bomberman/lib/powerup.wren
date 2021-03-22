import "../../lib/vec2d"
import "../../lib/entity"

class PowerUp is Entity {
	construct new(position, kind) {
		super(position, Vec2d.tile)
		_kind = kind
		sprite = (kind == 1) ? 56 : 58
	}

	apply(player) {
		if (!alive) return
		if (_kind == 1) {
			player.bombCount = player.bombCount + 1
			return
		}
		player.bombPower = player.bombPower + 1
	}

	TIC() {
		TIC.spr(sprite, position.x, position.y, 0, 1, false, 0, size.x / 8, size.y / 8)
	}
}