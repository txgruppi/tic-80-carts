import "../../lib/entity"
import "../../lib/vec2d"
import "../graphics/sprites"

class Drop is Entity {
 construct new(game, position, kind) {
  super(game, position, Vec2d.tileSize)
		sprite = (kind.abs == 1) ? Sprites.PowerUpBombCount : Sprites.PowerUpBombPower
 }

 draw() {
		TIC.spr(sprite, position.x, position.y, 0, 1, false, 0, size.x / 8, size.y / 8)
 }
}