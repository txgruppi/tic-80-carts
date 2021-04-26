import "../graphics/palette"
import "../inputs/buttons"
import "./scene"
import "./play"

class MenuScene is Scene {
	construct new(game) {
  super(game)

		_index = 0
	}

 handleInput() {
  if (game.gamepad.btnr(Buttons.P1A)) {
   game.scene = PlayScene.new(game, _index == 0 ? 2 : 4)
   return
  }

  var dy = 0
  if (game.gamepad.btnp(Buttons.P1Up)) dy = dy - 1
  if (game.gamepad.btnp(Buttons.P1Down)) dy = dy + 1
  _index = _index + dy
  if (_index < 0) {
   _index = 1
  } else if (_index > 1) {
   _index = 0
  }
 }

 drawBackground() {
  // wall
  TIC.rect(198, 0, 42, 136, GamePalette.DarkGray)

  // long floor
  TIC.tri(-16, -19, 110, 137, 240, 136, GamePalette.DarkerBrown)

  // short floor
  TIC.tri(126, 135, 240, 97, 240, 136, GamePalette.DarkerBrown)

  TIC.spr(Sprites.TitleChar01, 66, 6, GamePalette.Green, 1, 0, 0, 2, 7)
  TIC.spr(Sprites.TitleChar02, 138, 58, GamePalette.LightBlue, 1, 0, 0, 8, 10)
 }

 drawOptions() {
		TIC.print(" 2 players", 0, 100, 14)
		TIC.print(" 4 players", 0, 108, 14)
		TIC.print(">", 0, 100 + 8*_index, 14)
 }

 TIC() {
  super.TIC()

  handleInput()

  TIC.cls()
  drawBackground()
  drawOptions()
 }
}