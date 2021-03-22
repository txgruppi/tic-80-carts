class Entity {
	construct new(position, size) {
		_position = position
		_size = size
		_alive = true
		_framesToLive = null
		_sprite = null
	}

	sprite { _sprite }
	sprite=(v) { _sprite = v }

	position { _position }
	position=(o) { _position = o }

	size { _size }
	size=(o) { _size = o }

	alive { _alive }
	alive=(v) { _alive = v }

	framesToLive { _framesToLive }
	framesToLive=(v) { _framesToLive = v }

	TIC() {}
}