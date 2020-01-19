extends TileMap
class_name Board

onready var _shadow_mapper = $ShadowMapper
onready var _tile_visibility_painter = $TileVisibilityPainter

export (Vector2) var board_size
export (int) var tile_size

var _grid := []

func _ready() -> void:
	_grid = _init_grid(board_size)
	_shadow_mapper.init(self)
	#events.connect("tile_was_seen", self, "_on_tile_was_seen")
	#events.connect("tile_went_out_of_view", self, "_on_tile_went_out_of_view")

func _init_grid(size: Vector2) -> Array:
	var result = []
	for x in range(size.x):
		result.append([])
		for y in range(size.y):
			var map_pos = Vector2(x, y)
			result[x].append(Tile.new(map_pos))
			_tile_visibility_painter.mask_full(map_pos)
	return result


func get_tile_at_map_pos(map_pos: Vector2) -> Tile:
	return _grid[map_pos.x][map_pos.y]


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
	return map_to_world(cell_target) + (cell_size / 2)


func add_entity(entity: Entity, pos: Vector2) -> Vector2:
	set_cellv(pos, entity.type)
	return map_to_world(pos) + cell_size / 2


func contains(map_pos: Vector2) -> bool:
	return map_pos.x >= 0 and map_pos.y >= 0 and map_pos.x < board_size.x and map_pos.y < board_size.y


func get_visible_tiles() -> Array:
	#(_tile_visibility_painter.get_used_cells_by_id(globals.MASK_CELL_TYPES.EMPTY))
	return _tile_visibility_painter.get_used_cells_by_id(globals.MASK_CELL_TYPES.EMPTY)

func is_wall(map_pos: Vector2) -> bool:
	var cell_type = get_cellv(map_pos)
	return cell_type != globals.CELL_TYPES.EMPTY && cell_type != globals.CELL_TYPES.OBJECT


func mark_tile_visible(tile_map_pos: Vector2) -> void:
	var tile = get_tile_at_map_pos(tile_map_pos)
	tile.set_is_visible(true)

func mark_tile_invisible(tile_map_pos: Vector2) -> void:
	var tile = get_tile_at_map_pos(tile_map_pos)
	tile.set_is_visible(false)
