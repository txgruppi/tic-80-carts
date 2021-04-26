import "./eventemitter"

class Entity is EventEmitter {
	construct new(game, position, size) {
		super()
		_game = game
		_position = position
		_size = size
		_alive = true
		_framesToLive = null
		_sprite = null
	}

	game { _game }

	position { _position }
	position=(o) { _position = o }

	size { _size }
	size=(o) { _size = o }

	alive { _alive }

	framesToLive { _framesToLive }
	framesToLive=(v) { _framesToLive = v }

	sprite { _sprite }
	sprite=(v) { _sprite = v }

	center { _size.clone / 2 + _position }
	center=(vec) { _position = vec - (_size.clone / 2) }

	top { _position.y }
	top=(vec) { _position.y = vec.y }

	bottom { _position.y + _size.y }
	bottom=(vec) { _position.y = vec.y - _size.y }

	left { _position.x }
	left=(vec) { _position.x = vec.x }

	right { _position.x + _size.x }
	right=(vec) { _position.x = vec.x - _size.x }

	damage() {}

	kill() {
		emitEvent("dead")
		_alive = false
	}

	destroy() {
		emitEvent("destroyed")
		removeAllListeners()
	}

	update(){}
	draw(){}
}