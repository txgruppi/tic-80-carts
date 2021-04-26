import "./vec2d"

class Screen {
	static position { Vec2d.zero }

	static size {
		if (__size == null) {
			__size = Vec2d.new(240, 136)
		}
		return __size
	}

	static toString { "Screen(%(position.x),%(position.y),%(size.x),%(size.y))" }
}