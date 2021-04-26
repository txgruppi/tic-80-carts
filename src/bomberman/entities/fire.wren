import "../../lib/entity"
import "../../lib/vec2d"
import "../graphics/sprites"

class Fire is Entity {
 static growFrom(game, center, power) {
  game.scene.add(Fire.new(game, center.clone))
  growFrom(game, center, power, Vec2d.up * 8)
  growFrom(game, center, power, Vec2d.down * 8)
  growFrom(game, center, power, Vec2d.left * 8)
  growFrom(game, center, power, Vec2d.right * 8)
 }

 static growFrom(game, center, power, dir) {
  var target = center.clone
  for (i in 0...power) {
   target = target + dir
   var tileX = ((target.x - game.scene.arena.position.x) / 8).floor
   var tileY = ((target.y - game.scene.arena.position.y) / 8).floor
   if (TIC.fget(TIC.mget(tileX, tileY),0)) return
   var fire = Fire.new(game, target.clone)
   var breakable = game.collide(target, game.scene.breakables)
   if (breakable) {
    breakable.damage()
    breakable.framesToLive = fire.framesToLive
    return
   }
   var bomb = game.collide(target, game.scene.bombs)
   if (bomb) {
    if (bomb.framesToLive > fire.framesToLive) {
     bomb.framesToLive = fire.framesToLive
    }
    return
   }
   var drop = game.collide(target, game.scene.drops)
   if (drop) {
     drop.kill()
   }
   game.scene.add(fire)
  }
 }

 construct new(game, position) {
  super(game, position, Vec2d.tileSize)
		sprite = Sprites.Fire
		_spriteCount = 4
		framesToLive = 30
		_framesPerSprite = framesToLive / _spriteCount
		_tick = 0
 }

	update() {
  framesToLive = framesToLive - 1
  if (framesToLive <= 0) {
   kill()
   return
  }
	}

 draw() {
		TIC.spr(sprite + (_tick / _framesPerSprite).floor, position.x, position.y, 0, 1, false, 0, size.x / 8, size.y / 8)
		_tick = _tick + 1
 }
}