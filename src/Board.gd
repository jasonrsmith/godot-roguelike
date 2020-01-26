extends TileMap
class_name Board

onready var _shadow_mapper = $ShadowMapper
onready var _tile_visibility_painter = $TileVisibilityPainter
onready var _bsp = $BSP
onready var _npc_area = $NPCArea
onready var _player_entity = $PlayerEntity
onready var _debug_grid = $DebugGrid

onready var _chad_entity = preload("res://src/entities/Chad.tscn")
onready var _snake_entity = preload("res://src/entities/Snake.tscn")

onready var _astar = AStar.new()

export (Vector2) var board_size
export (int) var tile_size
export (bool) var collisions_enabled
export (bool) var debug_grid

var _grid := []
var _bsp_map_nodes := []
var _walkable_cells := []

func _init_grid(size: Vector2) -> Array:
	var result = []
	for x in range(size.x):
		result.append([])
		for y in range(size.y):
			var map_pos = Vector2(x, y)
			var tile = Tile.new(map_pos)
			tile.set_is_wall(true)
			set_cellv(map_pos, globals.CELL_TYPES.WALL)
			result[x].append(tile)
			_tile_visibility_painter.mask_full(map_pos)
	if debug_grid:
		_debug_grid.draw_grid()
	return result

func init_map():
	_grid = _init_grid(board_size)
	_bsp_map_nodes = _bsp.gen_rooms(Rect2(Vector2(), board_size))
	var room_count: int = 0
	for node in _bsp_map_nodes:
		var room = node.room
		var halls = node.halls
		if room:
			fill_rect(room, globals.CELL_TYPES.FLOOR)
			#add_label_at(room.position, "Room" + String(room_count))
			room_count += 1
		if halls:
			for hall in halls:
				if Rect2(Vector2(), board_size).encloses(hall):
					fill_rect(hall, globals.CELL_TYPES.FLOOR)
	for cell in get_used_cells_by_id(globals.CELL_TYPES.FLOOR):
		var idx = get_map_pos_index(cell)
		_astar.add_point(idx, Vector3(cell.x, cell.y, 0.0))
	_shadow_mapper.init(self)
	_astar_connect_walkable_cells(_astar)

func _astar_connect_walkable_cells(astar: AStar):
	var points : Array = astar.get_points()
	for point in points:
		var map_pos = get_index_map_pos(point)
		var map_pos_relative = PoolVector2Array([
			Vector2(map_pos.x + 1, map_pos.y),
			Vector2(map_pos.x - 1, map_pos.y),
			Vector2(map_pos.x, map_pos.y + 1),
			Vector2(map_pos.x, map_pos.y - 1),
			Vector2(map_pos.x - 1, map_pos.y - 1),
			Vector2(map_pos.x + 1, map_pos.y - 1),
			Vector2(map_pos.x - 1, map_pos.y + 1),
			Vector2(map_pos.x + 1, map_pos.y + 1),
		])
		for map_pos in map_pos_relative:
			var relative_index = get_map_pos_index(map_pos)
			if not astar.has_point(relative_index):
				continue
			astar.connect_points(point, relative_index, false)

func find_path(map_pos_start: Vector2, map_pos_end: Vector2) -> Array:
	return _astar.get_point_path(
		get_map_pos_index(map_pos_start),
		get_map_pos_index(map_pos_end))

func populate_enemies() -> void:
	for node in _bsp_map_nodes:
		var room = node.room
		if !room:
			continue
		if !room.has_point(world_to_map(_player_entity.position)):
			var monster : Entity
			if globals.rng.randf() > 0.5:
				monster = _chad_entity.instance()
			else:
				monster = _snake_entity.instance()
			monster.position = add_entity(monster, (Vector2(
				room.position.x + room.size.x - 2,
				room.position.y + 2)))
			_npc_area.add_child(monster)


func add_label_at(map_pos: Vector2, text: String) -> void:
	var label = Label.new()
	label.text = text
	label.rect_position = map_to_world(map_pos)
	add_child(label)


func find_player_spawn_point() -> Vector2:
	var walk_size = 4
	var walk_horiz = true
	var walk_step = 0
	var p = Vector2()
	while get_tile_at_map_pos(p).is_wall:
		if walk_horiz:
			p = Vector2(p.x + 1, p.y)
		else:
			p = Vector2(p.x, p.y + 1)
		walk_step += 1
		if (walk_step % walk_size) == 0:
			walk_horiz = !walk_horiz
	return p

func fill_rect(region: Rect2, cell_type: int) -> void:
	for x in range(region.position.x, region.position.x + region.size.x):
		for y in range(region.position.y, region.position.y + region.size.y):
			var region_pos = Vector2(x, y)
			get_tile_at_map_pos(region_pos).set_is_wall(false)
			set_cellv(region_pos, cell_type)

func get_tile_at_map_pos(map_pos: Vector2) -> Tile:
	return _grid[map_pos.x][map_pos.y]

func get_map_pos_index(map_pos: Vector2) -> int:
	return map_pos.x + board_size.x * map_pos.y

func get_index_map_pos(idx: int) -> Vector2:
	return Vector2(idx % int(board_size.x), floor(idx / board_size.x))

func request_move(entity: Entity, direction: Vector2) -> Vector2:
	"""
	see if entity can move in given direction
	returns new position if successful
	returns 0 vector otherwise
	"""
	var cell_start : Vector2 = world_to_map(entity.position)
	var cell_target : Vector2 = cell_start + direction
	
	if !Rect2(Vector2(), board_size).has_point(cell_target):
		return Vector2()
	if !collisions_enabled or !get_tile_at_map_pos(cell_target).is_wall:
		return cell_target
	return Vector2()

func add_entity(entity: Entity, pos: Vector2) -> Vector2:
	return map_to_world(pos) + cell_size / 2

func contains(map_pos: Vector2) -> bool:
	return map_pos.x >= 0 and map_pos.y >= 0 and map_pos.x < board_size.x and map_pos.y < board_size.y

func get_visible_tiles() -> Array:
	return _tile_visibility_painter.get_used_cells_by_id(globals.MASK_CELL_TYPES.EMPTY)

func is_wall(map_pos: Vector2) -> bool:
	var cell_type = get_cellv(map_pos)
	return get_tile_at_map_pos(map_pos).is_wall

func mark_tile_visible(tile_map_pos: Vector2) -> void:
	var tile = get_tile_at_map_pos(tile_map_pos)
	tile.set_is_visible(true)

func mark_tile_invisible(tile_map_pos: Vector2) -> void:
	var tile = get_tile_at_map_pos(tile_map_pos)
	tile.set_is_visible(false)

