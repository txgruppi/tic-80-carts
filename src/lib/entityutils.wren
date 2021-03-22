class EntityUtils {
	static center(entity) { entity.size.clone / 2 + entity.position }
	static center(entity, vec) { entity.position = vec - (entity.size.clone / 2) }

	static top(entity) { entity.position.y }
	static top(entity, vec) { entity.position.y = vec }

	static bottom(entity) { entity.position.y + entity.size.y }
	static bottom(entity, vec) { entity.position.y = vec - entity.size.y }

	static left(entity) { entity.position.x }
	static left(entity, vec) { entity.position.x = vec }

	static right(entity) { entity.position.x + entity.size.x }
	static right(entity, vec) { entity.position.x = vec - entity.size.x }
}