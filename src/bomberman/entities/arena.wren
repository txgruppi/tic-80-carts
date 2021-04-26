import "../../lib/entity"
import "../../lib/vec2d"
import "../../lib/screen"

class Arena is Entity {
 construct new(game) {
  var size = Vec2d.new(17, 17) * 8
  var position = (Screen.size.clone - size) / 2
  super(game, position, size)
 }

 positionToTile(pos) {
  return (pos.clone - position) / 8
 }

 tileToPosition(tile) {
  return tile.clone * 8 + position
 }

 draw() {
  TIC.map(0, 0, 17, 17, position.x, position.y)
 }
}