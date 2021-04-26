import "./input"

class GamepadInput is Input {
 construct new() {
  super(Buttons.count) { |index| TIC.btn(index) }
 }
}