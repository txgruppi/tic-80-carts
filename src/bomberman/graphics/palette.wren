import "../../lib/palette"

class GamePalette is Palette {
 static Black { 0 }
 static DarkerBrown { 1 }
 static DarkBrown { 2 }
 static LightBrown { 3 }
 static LighterBrown { 4 }
 static Red { 5 }
 static Yellow { 6 }
 static Orange { 7 }
 static DarkBlue { 8 }
 static Blue { 9 }
 static LightBlue { 10 }
 static Green { 11 }
 static White { 12 }
 static LightGray { 13 }
 static Gray { 14 }
 static DarkGray { 15 }

	static reset() {
		Palette.reset()
	}

 static updateForPlayer(number) {
		if (number == 1) {
			Palette.set(8, 7)
			Palette.set(9, 7)
			Palette.set(10, 6)
		} else if (number == 2) {
			Palette.set(8, 6)
			Palette.set(9, 11)
			Palette.set(10, 11)
		} else if (number == 3) {
			Palette.set(8, 13)
			Palette.set(9, 12)
			Palette.set(10, 13)
		}
 }
}