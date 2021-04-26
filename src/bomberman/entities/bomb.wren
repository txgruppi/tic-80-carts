import "../../lib/entity"
import "../../lib/vec2d"
import "../graphics/sprites"

class Bomb is Entity {
 construct new(game, position, power) {
  super(game, position, Vec2d.tileSize)
  sprite = Sprites.SmallBomb
  _power = power
  framesToLive = 120
 }

 update() {
  framesToLive = framesToLive - 1
  if (framesToLive == 0) {
   Fire.growFrom(game, position, _power)
   kill()
   return
  }
  if (framesToLive % 30 == 0) {
   sprite = sprite == Sprites.SmallBomb ? Sprites.BigBomb : Sprites.SmallBomb
  }
 }

 draw() {
		TIC.spr(sprite, position.x, position.y, 0, 1, false, 0, size.x / 8, size.y / 8)
 }
}