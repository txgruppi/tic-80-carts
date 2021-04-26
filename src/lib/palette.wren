class Palette {
 static MEMADDR { 0x3FF0 }

 static set(curr, next) {
  TIC.poke4(Palette.MEMADDR * 2 + curr, next)
 }

 static reset() {
  for (i in 0...16) {
   Palette.set(i, i)
  }
 }
}