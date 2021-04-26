import "../../lib/entity"
import "../../lib/vec2d"
import "../graphics/sprites"
import "./drop"

class Breakable is Entity {
 construct new(game, position) {
  super(game, position, Vec2d.tileSize)
  sprite = Sprites.Breakable
  _dropRate = 0.2
 }

 damage() {
  sprite = Sprites.BreakableDamaged
 }

 maybeDropSomething() {
  if (game.scene.random.float() > _dropRate) return
  game.scene.add(Drop.new(game, position, game.scene.random.int(1, 3)))
 }

 kill() {
  super.kill()
  maybeDropSomething()
 }

 update() {
  if (framesToLive != null) {
   framesToLive = framesToLive - 1
   if (framesToLive <= 0) {
    kill()
   }
  }
 }

 draw() {
  TIC.spr(sprite, position.x, position.y, 0, 1, false, 0, size.x / 8, size.y / 8)
 }
}