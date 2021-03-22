class Vec2d {
	static zero {
		if (__zero == null) {
			__zero = Vec2d.new(0, 0)
		}
		return __zero
	}

	static unit {
		if (__unit == null) {
			__unit = Vec2d.new(1, 1)
		}
		return __unit
	}

	static left {
		if (__left == null) {
			__left = Vec2d.new(-1, 0)
		}
		return __left
	}

	static right {
		if (__right == null) {
			__right = Vec2d.new(1, 0)
		}
		return __right
	}

	static up {
		if (__up == null) {
			__up = Vec2d.new(0, -1)
		}
		return __up
	}

	static down {
		if (__down == null) {
			__down = Vec2d.new(0, 1)
		}
		return __down
	}

	static tile {
		if (__tile == null) {
			__tile = Vec2d.new(8, 8)
		}
		return __tile
	}

	construct new(x, y) {
		_x = x
		_y = y
	}

	x { _x }
	x=(o) { _x = o }

	y { _y }
	y=(o) { _y = o }

	toString { "Vec2d(" + _x.toString + "," + _y.toString + ")" }

	clone { Vec2d.new(_x, _y) }

	map_(name, x, y, fn) {
		_x = fn.call(_x, x)
		_y = fn.call(_y, y)
		return this
	}

	map_(name, o, fn) {
		if (o is Vec2d) {
			return map_(name, o.x, o.y, fn)
		}
		if (o is List) {
			return map_(name, o[0], o[1], fn)
		}
		if (o is Map) {
			return map_(name, o["x"], o["y"], fn)
		}
		if (o is Num) {
			return map_(name, o, o, fn)
		}
		Fiber.abort("%(this.type) %(name) %(o.type) is not supported")
	}

	cmp_(name, op, x, y, fn) {
		if (op == "and") {
			return fn.call(_x, x) && fn.call(_y, y)
		}
		return fn.call(_x, x) || fn.call(_y, y)
	}

	cmp_(name, op, o, fn) {
		if (o is Vec2d) {
			return cmp_(name, op, o.x, o.y, fn)
		}
		if (o is List) {
			return cmp_(name, op, o[0], o[1], fn)
		}
		if (o is Map) {
			return cmp_(name, op, o["x"], o["y"], fn)
		}
		if (o is Num) {
			return cmp_(name, op, o, o, fn)
		}
		Fiber.abort("%(this.type) %(name) %(o.type) is not supported")
	}

	abs {
		_x = _x.abs
		_y = _y.abs
		return this
	}

	- {
		_x = -_x
		_y = -_y
		return this
	}
	+(o) { map_("+", o) { |a, b| a + b } }
	-(o) { map_("-", o) { |a, b| a - b } }
	*(o) { map_("*", o) { |a, b| a * b } }
	/(o) { map_("/", o) { |a, b| a / b } }
	%(o) { map_("\%", o) { |a, b| a % b } }
	==(o) { o is Null ? false : cmp_("==", "and", o) { |a,b| a == b } }
	!=(o) { o is Null ? true : cmp_("!=", "or", o) { |a,b| a != b } }
}