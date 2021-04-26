import "./input"

class KeyboardInput is Input {
 construct new() {
  super(Keys.count) { |index| TIC.key(index+1) }
 }

 btn(code) { super.btn(code-1) }
 btnp(code) { super.btnp(code-1) }
 btnr(code) { super.btnr(code-1) }
}