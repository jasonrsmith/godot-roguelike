extends Position2D
class_name NPCArea

var _entity_idx := {}

func _ready():
	globals.npc_area = self

func add_npc(entity: Entity):
	var map_pos: Vector2 = entity.get_map_pos()
	assert(!_entity_idx.has(map_pos))
	_entity_idx[map_pos] = entity
	add_child(entity)
	if globals.board.is_tile_visible(entity.get_map_pos()) or globals.debug_settings.disable_entity_hiding:
		entity.show()
	else:
		entity.hide()
