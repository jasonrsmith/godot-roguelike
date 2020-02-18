extends Position2D
class_name ActorArea

var _entity_idx := {}

func _ready() -> void:
	globals.actor_area = self

func add(entity: Entity) -> void:
	var map_pos: Vector2 = entity.get_map_pos()
	assert(!_entity_idx.has(map_pos))
	_entity_idx[map_pos] = entity
	add_child(entity)
	if globals.board.is_tile_visible(entity.get_map_pos()) or globals.debug_settings.disable_entity_hiding:
		entity.show()
	else:
		entity.hide()

func get_at_map_pos(map_pos: Vector2) -> Entity:
	if !_entity_idx.has(map_pos):
		return null
	return _entity_idx[map_pos]

func remove(entity: Entity):
	var map_pos = entity.get_map_pos()
	assert(_entity_idx.has(map_pos))
	_entity_idx.erase(map_pos)

func move(from: Vector2, to: Vector2) -> void:
	assert(_entity_idx.has(from))
	var entity : Entity = _entity_idx[from]
	_entity_idx[to] = entity
	_entity_idx.erase(from)
