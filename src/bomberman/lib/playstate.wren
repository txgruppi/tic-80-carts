import "../../lib/vec2d"
import "../../lib/input"
import "../../lib/numberutils"
import "./arena"
import "./player"
import "./bomb"
import "./fire"
import "./box"
import "./powerup"

class PlayState {
	construct new(numberOfPlayers) {
		_initialized = false
		_numberOfPlayers = numberOfPlayers
		_random = Random.new()
		_arena = Arena.new()
		_playerActionDown = [false, false, false, false]
		_players = [
			Player.new(0, _arena.position.clone + [8, 8]),
			_numberOfPlayers > 1 ? Player.new(1, _arena.position.clone + _arena.size.clone - [16, 16]) : null,
			_numberOfPlayers > 2 ? Player.new(2, _arena.position.clone + _arena.size.clone - [16, _arena.size.y - 8]) : null,
			_numberOfPlayers > 2 ? Player.new(3, _arena.position.clone + _arena.size.clone - [_arena.size.x - 8, 16]) : null,
		].where{ |o| o != null }.toList
		_alivePlayers = []
		_bombsAndFires = []
		_boxes = []
		_powerUps = []
	}

	handlePlayerInput(player) {
		if (!player.alive) return
		if (!_playerActionDown[player.number] && Input[player.number].action && player.bombCount > 0) {
			var bombPosition = player.distanceMoved > 5 ? player.targetPosition.clone : player.previousPosition.clone
			for (other in _bombsAndFires) {
				if (other is Bomb) {
					if (collide(bombPosition.x, bombPosition.y, other.position.x, other.position.y)) {
						return
					}
				}
			}
			_playerActionDown[player.number] = true
			player.bombCount = player.bombCount - 1
			_bombsAndFires.add(
				Bomb.new(
					bombPosition,
					player.bombPower,
					player.number
				)
			)
		}
		if (!Input[player.number].action) {
			_playerActionDown[player.number] = false
		}

		if (player.position != player.targetPosition) return

		var dx = 0
		var dy = 0
		if (Input[player.number].up) dy = dy - 1
		if (Input[player.number].down) dy = dy + 1
		if (Input[player.number].left) dx = dx - 1
		if (Input[player.number].right) dx = dx + 1

		if ((dx == 0 && dy != 0) || (dx != 0 && dy == 0)) {
			var targetX = player.position.x + dx * 8
			var targetY = player.position.y + dy * 8
			var tileX = (targetX - _arena.position.x) / 8
			var tileY = (targetY - _arena.position.y) / 8
			if (TIC.fget(TIC.mget(tileX, tileY),0)) return
			for (other in _alivePlayers) {
				if (other != player && collide(targetX, targetY, other.position.x, other.position.y)) {
					return
				}
			}
			for (box in _boxes) {
				if (collide(targetX, targetY, box.position.x, box.position.y)) {
					return
				}
			}
			for (o in _bombsAndFires) {
				if (o is Bomb && collide(targetX, targetY, o.position.x, o.position.y)) {
					return
				}
			}
			for (o in _powerUps) {
				if (collide(targetX, targetY, o.position.x, o.position.y)) {
					o.apply(player)
					o.alive = false
				}
			}
			player.distanceMoved = 0
			player.previousPosition = player.position.clone
			player.targetPosition = Vec2d.new(targetX, targetY)
		}
	}

	movePlayer(player) {
		if (!player.alive) return
		if (player.position == player.targetPosition) {
			player.animate = false
			return
		}

		if (player.position.y > player.targetPosition.y) {
			player.rotate = 0
		} else if (player.position.y < player.targetPosition.y) {
			player.rotate = 2
		} else if (player.position.x > player.targetPosition.x) {
			player.rotate = 3
		} else if (player.position.x < player.targetPosition.x) {
			player.rotate = 1
		}

		player.animate = true
		var diffX = player.targetPosition.x - player.position.x
		var diffY = player.targetPosition.y - player.position.y
		player.distanceMoved = player.distanceMoved + (NumberUtils.mid(-0.5, diffX, 0.5) + NumberUtils.mid(-0.5, diffY, 0.5)).abs
		player.position = player.position + [
			NumberUtils.mid(-0.5, diffX, 0.5),
			NumberUtils.mid(-0.5, diffY, 0.5),
		]
	}

	tickBombOrFire(o) {
		o.framesToLive = o.framesToLive - 1
		if (o.framesToLive > 0) {
			return
		}

		o.alive = false
		if (o is Bomb) {
			_players[o.playerNumber].bombCount = _players[o.playerNumber].bombCount + 1
			_bombsAndFires.add(Fire.new(o.position.clone))
			createFireInDirection(o.power, o.position.clone, Vec2d.left.clone)
			createFireInDirection(o.power, o.position.clone, Vec2d.right.clone)
			createFireInDirection(o.power, o.position.clone, Vec2d.up.clone)
			createFireInDirection(o.power, o.position.clone, Vec2d.down.clone)
		}
	}

	createFireInDirection(count, start, direction) {
		direction = direction * 8
		for (i in 0...count) {
			start = start + direction
			var fire = Fire.new(start.clone)
			for (box in _boxes) {
				if (collide(box.position.x, box.position.y, start.x, start.y)) {
					box.framesToLive = fire.framesToLive
					box.sprite = 14
					return
				}
			}
			for (o in _bombsAndFires) {
				if (o is Bomb && collide(o.position.x, o.position.y, start.x, start.y)) {
					if (o.framesToLive > fire.framesToLive) {
						o.framesToLive = fire.framesToLive
					}
					return
				}
			}
			for (o in _powerUps) {
				if (collide(o.position.x, o.position.y, start.x, start.y)) {
					o.alive = false
				}
			}
			var tile = (start.clone - _arena.position) / 8
			if (TIC.fget(TIC.mget(tile.x, tile.y),0)) {
				return
			}
			_bombsAndFires.add(fire)
		}
	}

	tickBox(box) {
		if (box.framesToLive == null) return
		if (box.framesToLive <= 0) {
			box.alive = false
			maybeSpawnPowerUp(box.position)
			return
		}
		box.framesToLive = box.framesToLive - 1
	}

	fillStageWithBoxes() {
		var tiles = (_arena.size.clone / 8).abs
		for (x in 1...tiles.x-1) {
			for (y in 1...tiles.y-1) {
				var isCorner = (NumberUtils.isBetween(1, x, 2) && NumberUtils.isBetween(1, y, 2)) ||
					(NumberUtils.isBetween(tiles.x-3, x, tiles.x-1) && NumberUtils.isBetween(1, y, 2)) ||
					(NumberUtils.isBetween(1, x, 2) && NumberUtils.isBetween(tiles.y-3, y, tiles.y-1)) ||
					(NumberUtils.isBetween(tiles.x-3, x, tiles.x-1) && NumberUtils.isBetween(tiles.y-3, y, tiles.y-1))
				var isWall = TIC.fget(TIC.mget(x, y), 0)
				if (!isCorner && !isWall && _random.float() > 0.5) {
					_boxes.add(Box.new(_arena.position.clone + Vec2d.new(x, y) * 8))
				}
			}
		}
	}

	maybeSpawnPowerUp(pos) {
		if (_random.float() > 0.2) return
		var kind = _random.int(1, 3)
		_powerUps.add(PowerUp.new(pos.clone, kind))
	}

	collidePlayersAndFires() {
		for (o in _bombsAndFires) {
			if (o is Fire) {
				for (player in _alivePlayers) {
					if (collide(player.position.x, player.position.y, o.position.x, o.position.y)) {
						player.alive = false
					}
				}
			}
		}
	}

	collide(x0, y0, x1, y1) {
		return (x0 - x1).abs < Vec2d.tile.x && (y0 - y1).abs < Vec2d.tile.y
	}

	playerStatsBox(player) {
		if (!player.alive) return
		var x = 0
		var y = 0
		if (player.number % 2 == 1) {
			x = Screen.size.x - 8*6
		}
		if (player.number > 1) {
			y = 8*6
		}
		TIC.rect(x, y, 8*6, 8*4, 3)
		TIC.print("player " + (player.number + 1).toString, x, y, 2)

		if (player.bombCountMax > player.bombCount) {
			var startPos = player.bombCount
			var emptyCount = player.bombCountMax - player.bombCount - 1
			for (i in 0..emptyCount) {
				TIC.spr(Sprites.bombOutline, (startPos+i)*8+x, y+8, 0)
			}
		}

		if (player.bombCount > 0) {
			for (i in 0..player.bombCount-1) {
				TIC.spr(Sprites.smallBomb, i*8+x, y+8, 0)
			}
		}

		TIC.print(player.bombPower, x+10, y+18, 2)
		//TIC.spr(Sprites.uibBombCount, x, y+8, 0)
		TIC.spr(Sprites.uiBombPower, x, y+16, 0)
	}

	checkEndGame(game) {
		if (_alivePlayers.count == 0) {
			game.state = GameOverState.new(null, -1, _numberOfPlayers)
		} else	if (_alivePlayers.count == 1) {
			game.state = GameOverState.new(null, _players[0].number, _numberOfPlayers)
		}
	}

	TIC(game){
		TIC.cls()

		if (!_initialized) {
			fillStageWithBoxes()
		}

		_arena.TIC()

		for (o in _bombsAndFires) {
			tickBombOrFire(o)
			if (o.alive) {
				o.TIC()
			}
		}

		for (o in _boxes) {
			tickBox(o)
			if (o.alive) {
				o.TIC()
			}
		}

		for (o in _powerUps) {
			if (o.alive) {
				o.TIC()
			}
		}

		for (player in _players) {
			handlePlayerInput(player)
			movePlayer(player)
			player.TIC()
			playerStatsBox(player)
		}

		collidePlayersAndFires()

		/* _players = _players.where { |o| o.alive }.toList */
		_alivePlayers = _players.where { |o| o.alive }.toList
		_bombsAndFires = _bombsAndFires.where { |o| o.alive }.toList
		_boxes = _boxes.where { |o| o.alive }.toList

		checkEndGame(game)

		_initialized = true
	}
}
