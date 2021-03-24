import "../../lib/vec2d"
import "../../lib/entity"
import "./sprites"

class Box is Entity {
	construct new(position) {
		super(position, Vec2d.tile)
		sprite = Sprites.box
		framesToLive = null
	}

	TIC() {
		TIC.spr(sprite, position.x, position.y, 0, 1, false, 0, size.x / 8, size.y / 8)
	}
}