class Input {
	construct new(players) {
		_players = players
	}

	static [playerNumber] {
		if (__instances == null) {
			__instances = [null, null, null, null]
		}
		if (__instances[playerNumber] == null) {
			__instances[playerNumber] = Input.new([playerNumber])
		}
		return __instances[playerNumber]
	}

	static any {
		if (__any == null) {
			__any = Input.new([0, 1, 2, 3])
		}
		return __any
	}

	some(btnIndex, thisFrame) {
		for (player in _players) {
			if (thisFrame ? TIC.btnp(btnIndex + player * 8) : TIC.btn(btnIndex + player * 8)) {
				return true
			}
		}
		return false
	}

	up          { some(0, false) }
	down        { some(1, false) }
	left        { some(2, false) }
	right       { some(3, false) }
	a           { some(4, false) }
	b           { some(5, false) }
	x           { some(6, false) }
	y           { some(7, false) }
	directional { up || down || left || right }
	action      { a || b || x || y }
	any         { directional || action }

	justUp          { some(0, true) }
	justDown        { some(1, true) }
	justLeft        { some(2, true) }
	justRight       { some(3, true) }
	justA           { some(4, true) }
	justB           { some(5, true) }
	justX           { some(6, true) }
	justY           { some(7, true) }
	justDirectional { justUp || justDown || justLeft || justRight }
	justAction      { justA || justB || justX || justY }
	justAny         { justDirectional || justAction }
}