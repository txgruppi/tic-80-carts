import "../../lib/entity"
import "../../lib/vec2d"
import "../../lib/numberutils"
import "../graphics/sprites"
import "../graphics/palette"
import "../inputs/buttons"
import "./bomb"
import "./fire"

class Player is Entity {
 construct new(game, position, number) {
  super(game, position, Vec2d.tileSize)
  sprite = Sprites.Player
  _number = number
		_targetPosition = position
  _previousPosition = position
  _distanceMoved = 0
  _rotate = 0
		_framesPerSprite = 5
		_animationDirection = 1
		_animationFrameCount = 0
		_animate = false
  _bombCount = 1
  _bombCountMax = 1
  _bombPower = 1
 }

	number { _number }

 handleActionInput() {
  if (!alive) return
  if (_bombCount <= 0 || !game.gamepad.btnp(Buttons.P1A + _number * 8)) {
   return
  }
  var bombPosition = _distanceMoved > 5 ? _targetPosition : _previousPosition
  if (game.collide(bombPosition, game.scene.bombs)) {
   return
  }
  _bombCount = _bombCount - 1
  var bomb = Bomb.new(game, bombPosition.clone, _bombPower)
  bomb.addEventListener("dead") { _bombCount = _bombCount + 1 }
  game.scene.add(bomb)
 }

 handleMovementInput() {
  if (!alive) return
		if (position != _targetPosition) return

		var dx = 0
		var dy = 0
		if (game.gamepad.btn(Buttons.P1Up + _number * 8)) dy = dy - 1
		if (game.gamepad.btn(Buttons.P1Down + _number * 8)) dy = dy + 1
		if (game.gamepad.btn(Buttons.P1Left + _number * 8)) dx = dx - 1
		if (game.gamepad.btn(Buttons.P1Right + _number * 8)) dx = dx + 1

		if ((dx == 0 && dy != 0) || (dx != 0 && dy == 0)) {
			var targetX = position.x + dx * 8
			var targetY = position.y + dy * 8
			var tileX = ((targetX - game.scene.arena.position.x) / 8).floor
			var tileY = ((targetY - game.scene.arena.position.y) / 8).floor
			if (TIC.fget(TIC.mget(tileX, tileY),0)) return
   if (game.collide(targetX, targetY, [game.scene.breakables, game.scene.bombs])) {
    return
   }
			if (game.collide(targetX, targetY, game.scene.players.where{ |o| o.alive }.toList)) {
				return
			}
			_animate = true
   _distanceMoved = 0
   _previousPosition = _targetPosition.clone
			_targetPosition = Vec2d.new(targetX, targetY)
  }
 }

 move() {
		if (!alive) return
		if (position == _targetPosition) {
			_animate = false
			return
		}

		if (position.y > _targetPosition.y) {
			_rotate = 0
		} else if (position.y < _targetPosition.y) {
			_rotate = 2
		} else if (position.x > _targetPosition.x) {
			_rotate = 3
		} else if (position.x < _targetPosition.x) {
			_rotate = 1
		}

		var diffX = _targetPosition.x - position.x
		var diffY = _targetPosition.y - position.y
  _distanceMoved = _distanceMoved + (NumberUtils.mid(-0.5, diffX, 0.5) + NumberUtils.mid(-0.5, diffY, 0.5)).abs
		position = position + [
			NumberUtils.mid(-0.5, diffX, 0.5),
			NumberUtils.mid(-0.5, diffY, 0.5),
		]
 }

	animate() {
		if (!alive) return
		if (!_animate) return
		_animationFrameCount = _animationFrameCount + 1
		if (_animationFrameCount == _framesPerSprite) {
			_animationFrameCount = 0
			sprite = sprite + _animationDirection
			if (TIC.fget(sprite, 1) || TIC.fget(sprite, 2)) {
				_animationDirection = _animationDirection * -1
			}
		}
	}

	collideWithFire() {
		if (game.collide(this, game.scene.fires)) {
			kill()
		}
	}

	collideWithDrops() {
		var drop = game.collide(this, game.scene.drops)
		if (drop) {
			applyDrop(drop)
			drop.kill()
		}
	}

	applyDrop(drop) {
		if (drop.sprite == Sprites.PowerUpBombCount) {
			_bombCount = _bombCount + 1
			return
		}
		if (drop.sprite == Sprites.PowerUpBombPower) {
			_bombPower = _bombPower + 1
		}
	}

	kill() {
		sprite = Sprites.DeadPlayer
		super.kill()
	}

 update() {
		if (!alive) return

  handleMovementInput()
  handleActionInput()

		collideWithFire()
		collideWithDrops()

  move()
		animate()
 }

 draw() {
		GamePalette.updateForPlayer(_number)
		TIC.spr(sprite, position.x, position.y, 0, 1, 0, _rotate, size.x / 8, size.y / 8)
		GamePalette.reset()
 }
}