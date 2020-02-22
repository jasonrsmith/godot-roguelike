extends TileMap
class_name Board

onready var _astar = AStar.new()

export (Vector2) var board_size
export (int) var tile_size
export (bool) var collisions_enabled

var _grid := []
var _bsp_map_nodes := []
var _walkable_cells := []
var _visible_tiles := {}

func _ready():
	globals.board = self
	events.connect("tile_was_seen", self, "_on_tile_was_seen")
	events.connect("tile_went_out_of_view", self, "_on_tile_went_out_of_view")

func _init_grid(size: Vector2) -> Array:
	var result = []
	# fill entire rect with walls
	for x in range(size.x):
		result.append([])
		for y in range(size.y):
			var map_pos = Vector2(x, y)
			var tile = Tile.new(map_pos)
			result[x].append(tile)
			tile.set_is_wall(true)
			set_cellv(map_pos, globals.CELL_TYPES.WALL)
			events.emit_signal("tile_was_obscured", map_pos)
	return result

func init_map():
	_grid = _init_grid(board_size)
	_bsp_map_nodes = globals.bsp.gen_rooms(Rect2(Vector2(), board_size))
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
	var start := get_map_pos_index(map_pos_start)
	var end := get_map_pos_index(map_pos_end)
	#_astar.set_point_disabled(start, false)
	#_astar.set_point_disabled(end, false)
	var path : Array = _astar.get_point_path(start, end)
	#_astar.set_point_disabled(start)
	#_astar.set_point_disabled(end)
	return path

func populate_rooms() -> void:
	for node in _bsp_map_nodes:
		var room = node.room
		if !room:
			continue
		if !room.has_point(world_to_map(globals.player_entity.position)):
			var monsters : Array = globals.spawner.spawn_room(
				room, globals.SPAWN_TYPE_RANDOM_MONSTER, -2, 5)
			for monster in monsters:
				globals.actor_area.add(monster)
			var items : Array = globals.spawner.spawn_room(
				room, globals.SPAWN_TYPE_RANDOM_ITEM, 1, 2)
			for item in items:
				globals.item_area.add_item(item)

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
			var tile := get_tile_at_map_pos(region_pos)
			tile.set_is_wall(false)
			set_cellv(region_pos, cell_type)
			#tile.cell_type = cell_type

func get_tile_at_map_pos(map_pos: Vector2) -> Tile:
	if map_pos.x >= board_size.x or map_pos.y >= board_size.y:
		return null
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

	# out of bounds
	if !Rect2(Vector2(), board_size).has_point(cell_target):
		return Vector2()
	# colliding with wall
	if collisions_enabled and get_tile_at_map_pos(cell_target).is_wall:
		return Vector2()
	# colliding with other entity
	if globals.actor_area.get_at_map_pos(cell_target):
		return Vector2()

	if entity is ActorEntity:
		globals.actor_area.move(cell_start, cell_target)
#	_astar.set_point_disabled(get_map_pos_index(cell_target))
#	_astar.set_point_disabled(get_map_pos_index(cell_start), false)
	return cell_target

func contains(map_pos: Vector2) -> bool:
	return map_pos.x >= 0 and map_pos.y >= 0 and map_pos.x < board_size.x and map_pos.y < board_size.y

func get_visible_tiles() -> Array:
	return _visible_tiles.keys()
	#return _tile_visibility_painter.get_used_cells_by_id(globals.MASK_CELL_TYPES.EMPTY)

func is_wall(map_pos: Vector2) -> bool:
	var cell_type = get_cellv(map_pos)
	if cell_type == -1:
		return false
	return get_tile_at_map_pos(map_pos).is_wall

func mark_tile_visible(tile_map_pos: Vector2) -> void:
	_visible_tiles[tile_map_pos]= true
	var tile = get_tile_at_map_pos(tile_map_pos)
	tile.set_is_visible(true)
	var entity : Entity = globals.actor_area.get_at_map_pos(tile_map_pos)
	if entity and !entity.is_visible_in_tree():
		entity.show()

func mark_tile_invisible(tile_map_pos: Vector2) -> void:
	_visible_tiles.erase(tile_map_pos)
	var tile = get_tile_at_map_pos(tile_map_pos)
	tile.set_is_visible(false)
	var entity : Entity = globals.actor_area.get_at_map_pos(tile_map_pos)
	if entity and entity.is_visible_in_tree() and !globals.debug_settings.disable_entity_hiding:
		print_debug("** hiding ent" + str(entity))
		globals.console.print_line(entity.display_name + " is out of fov and is now hidden", globals.LOG_CAT.ERROR)
		entity.hide()

func is_tile_visible(tile_map_pos: Vector2) -> bool:
	var tile : Tile = get_tile_at_map_pos(tile_map_pos)
	return tile.get_is_visible()

func set_point_disabled_for_path(map_pos: Vector2, disable=true) -> void:
	_astar.set_point_disabled(get_map_pos_index(map_pos), disable)

func get_entities_surrounding_map_pos(map_pos: Vector2) -> Array:
	var surrounding_entities := []
	for x in range(-1, 2):
		for y in range(-1, 2):
			if x == 0 and y == 0:
				continue
			var adjacent_pos := map_pos + Vector2(x, y)
			if globals.actor_area.get_at_map_pos(adjacent_pos):
				surrounding_entities.append(adjacent_pos)
	return surrounding_entities

func get_mouse_map_pos() -> Vector2:
	var world_pos = globals.camera.get_global_mouse_position()
	return globals.board.world_to_map(world_pos)

func _on_tile_was_seen(map_pos: Vector2):
	var tile := get_tile_at_map_pos(map_pos)
	#set_cellv(map_pos, tile.cell_type)
	var entity : Entity = globals.actor_area.get_at_map_pos(map_pos)
	if entity:
		entity.show()

func _on_tile_went_out_of_view(map_pos: Vector2):
	var entity : Entity = globals.actor_area.get_at_map_pos(map_pos)
	if entity and !globals.debug_settings.disable_entity_hiding:
		entity.hide()
