class Palette {
	static ADDR { 0x3FF0 }

	static set(curr, next) {
			TIC.poke4(Palette.ADDR * 2 + curr, next)
	}

	static reset() {
		for (i in 0...16) {
			TIC.poke4(Palette.ADDR * 2 + i, i)
		}
	}
}