extends TileMap
class_name Board


func _ready() -> void:
	pass


func request_move(entity: Entity, direction: Vector2) -> Vector2:
	"""
	see if entity can move in given direction
	returns new position if successful
	returns 0 vector otherwise
	"""
	var cell_start : Vector2 = world_to_map(entity.position)
	var cell_target : Vector2 = cell_start + direction
	
	var cell_target_type : int = get_cellv(cell_target)
	if cell_target_type == globals.CELL_TYPES.EMPTY or cell_target_type == globals.CELL_TYPES.OBJECT:
		return update_entity_position(entity, cell_start, cell_target)
	return Vector2()


func update_entity_position(entity: Entity, cell_start : Vector2, cell_target : Vector2) -> Vector2:
	set_cellv(cell_target, entity.type)
	set_cellv(cell_start, globals.CELL_TYPES.EMPTY)
	return map_to_world(cell_target) + cell_size / 2


func add_entity(entity: Entity, pos: Vector2) -> Vector2:
	set_cellv(pos, entity.type)
	return map_to_world(pos) + cell_size / 2