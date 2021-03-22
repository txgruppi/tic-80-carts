import "../../lib/vec2d"
import "../../lib/screen"
import "../../lib/entity"

class Arena is Entity {
	construct new() {
		var size = Vec2d.new(17, 17) * 8
		var position = (Screen.size.clone - size) / 2
		super(position, size)
	}

	TIC() {
		TIC.map(0, 0, 17, 17, position.x, position.y)
	}
}