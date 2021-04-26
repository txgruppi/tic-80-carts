import "../../lib/numberutils"
import "../entities/arena"
import "../entities/player"
import "../entities/bomb"
import "../entities/breakable"
import "../entities/fire"
import "../entities/drop"
import "./scene"
import "./gameover"

class PlayScene is Scene {
 construct new(game, numberOfPlayers) {
  super(game)

  _numberOfPlayers = numberOfPlayers
  _random = Random.new()
  _arena = Arena.new(game)

  reset()
 }

 random { _random }
 arena { _arena }
 players { _players }
 bombs { _bombs }
 fires { _fires }
 breakables { _breakables }
 drops { _drops }

 reset() {
  _players = []
  _bombs = []
  _fires = []
  _breakables = []
  _drops = []

  populatePlayers()
  populateBreakables()
 }

 add(o) {
  if (o is Fire) {
   _fires.add(o)
  } else if (o is Breakable) {
   _breakables.add(o)
  } else if (o is Bomb) {
   _bombs.add(o)
  } else if (o is Drop) {
   _drops.add(o)
  }
 }

 remove(o) {
  if (o is Fire) {
   _fires.remove(o)
  } else if (o is Breakable) {
   _breakables.remove(o)
  } else if (o is Bomb) {
   _bombs.remove(o)
  } else if (o is Drop) {
   _drops.remove(o)
  }
 }

 playerStartPosition(number) {
  if (number == 0) {
   return _arena.position.clone + [8, 8]
  } else if (number == 1) {
			return _arena.position.clone + _arena.size - [16, 16]
  } else if (number == 2) {
			return _arena.position.clone + _arena.size - [16, _arena.size.y - 8]
  } else if (number == 3) {
			return _arena.position.clone + _arena.size - [_arena.size.x - 8, 16]
  }
 }

 populatePlayers() {
  for (i in 0..._numberOfPlayers) {
   _players.add(Player.new(game, playerStartPosition(i), i))
  }
 }

 populateBreakables() {
  var tiles = (_arena.size.clone / 8).abs
  for (x in 1...tiles.x-1) {
   for (y in 1...tiles.y-1) {
				var isCorner = (NumberUtils.isBetween(1, x, 2) && NumberUtils.isBetween(1, y, 2)) ||
					(NumberUtils.isBetween(tiles.x-3, x, tiles.x-1) && NumberUtils.isBetween(1, y, 2)) ||
					(NumberUtils.isBetween(1, x, 2) && NumberUtils.isBetween(tiles.y-3, y, tiles.y-1)) ||
					(NumberUtils.isBetween(tiles.x-3, x, tiles.x-1) && NumberUtils.isBetween(tiles.y-3, y, tiles.y-1))
				var isWall = TIC.fget(TIC.mget(x, y), 0)
				if (!isCorner && !isWall && _random.float() > 0.5) {
					_breakables.add(Breakable.new(game, Vec2d.new(x, y) * 8 + _arena.position))
				}
   }
  }
 }

 updateEntities() {
  var oupdate = Fn.new { |o| o.update() }
  _players.each(oupdate)
  _fires.each(oupdate)
  _bombs.each(oupdate)
  _breakables.each(oupdate)
 }

 drawEntities() {
  var odraw = Fn.new { |o| o.draw() }
  _players.where{ |o| !o.alive }.each(odraw)
  _breakables.each(odraw)
  _drops.each(odraw)
  _fires.each(odraw)
  _bombs.each(odraw)
  _players.where{ |o| o.alive }.each(odraw)
 }

 clearDeadEntities() {
  var oalive = Fn.new { |o| o.alive }
  _bombs = _bombs.where(oalive).toList
  _fires = _fires.where(oalive).toList
  _breakables = _breakables.where(oalive).toList
  _drops = _drops.where(oalive).toList
 }

 checkEndGame() {
  var alivePlayers = _players.where{ |o| o.alive }.toList
  if (alivePlayers.count == 1) {
   game.scene = GameOverScene.new(game, _numberOfPlayers, alivePlayers[0].number)
  } else if (alivePlayers.count == 0) {
   game.scene = GameOverScene.new(game, _numberOfPlayers, -1)
  }
 }

 TIC() {
  super.TIC()

  TIC.cls()
  _arena.draw()

  updateEntities()
  clearDeadEntities()
  drawEntities()

  checkEndGame()
 }
}