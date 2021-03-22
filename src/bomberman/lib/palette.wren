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

	static updateForPlayer(number) {
		if (number == 1) {
			Palette.set(10, 6)
			Palette.set(9, 7)
			Palette.set(8, 7)
		} else if (number == 2) {
			Palette.set(8, 15)
			Palette.set(9, 14)
			Palette.set(10, 13)
		} else if (number == 3) {
			Palette.set(8, 13)
			Palette.set(10, 13)
			Palette.set(9, 12)
		}
	}
}