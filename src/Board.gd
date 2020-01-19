extends TileMap
class_name Board

onready var _shadow_mapper = $ShadowMapper
onready var _tile_visibility_painter = $TileVisibilityPainter

export (Vector2) var board_size
export (int) var tile_size

var _grid := []

class BSPNode:
	const MIN_SIZE = 6.0
	
	var map_pos: Vector2
	var size: Vector2
	var left: BSPNode
	var right: BSPNode
	var rng: RandomNumberGenerator
	var room: Rect2
	var halls : Array
	
	func _init(map_pos: Vector2, size: Vector2) -> void:
		self.map_pos = map_pos
		self.size = size
		rng = RandomNumberGenerator.new()
		rng.randomize()
	
	func split() -> bool:
		if left != null and right != null:
			return false
		
		var split_horiz: bool
		if size.x > size.y and size.x / size.y >= 1.25:
			split_horiz = false
		elif size.y > size.x and size.y / size.x >= 1.25:
			split_horiz = true
		else:
			split_horiz = rng.randf() > 0.5
		
		var max_size: float
		if split_horiz:
			max_size = size.y - MIN_SIZE
		else:
			max_size = size.x - MIN_SIZE
		
		if max_size <= MIN_SIZE:
			return false
		
		var split_pos = floor(rng.randf_range(MIN_SIZE, max_size))
		if split_horiz:
			left = BSPNode.new(map_pos, Vector2(size.x, split_pos))
			right = BSPNode.new(
				Vector2(map_pos.x, map_pos.y + split_pos),
				Vector2(size.x, size.y - split_pos))
		else:
			left = BSPNode.new(map_pos, Vector2(split_pos, size.y))
			right = BSPNode.new(
				Vector2(map_pos.x + split_pos, map_pos.y),
				Vector2(size.x - split_pos, size.y))
		return true
	
	func create_rooms():
		if left != null or right != null:
			if left != null:
				left.create_rooms()
			if right != null:
				right.create_rooms()
			if left != null and right != null:
				create_hall(left.get_room(), right.get_room())
		else:
			var room_size = Vector2(
				floor(rng.randf_range(4, size.x - 2)),
				floor(rng.randf_range(4, size.y - 2)))
			var room_pos = Vector2(
				floor(rng.randf_range(1, size.x - room_size.x - 1)),
				floor(rng.randf_range(1, size.y - room_size.y - 1)))
			room = Rect2(map_pos + room_pos, room_size)
	
	func get_room() -> Rect2:
		if room != Rect2():
			return room
		var left_room: Rect2
		var right_room: Rect2
		if left != null:
			left_room = left.get_room()
		if right != null:
			right_room = right.get_room()
		if left_room == null and right_room == null:
			return Rect2()
		elif right_room == null:
			return left_room
		elif left_room == null:
			return right_room
		elif rng.randf() > 0.5:
			return left_room
		else:
			return right_room
	
	func create_hall(room1: Rect2, room2: Rect2) -> void:
		halls = []
		var point1 = Vector2(
			floor(rng.randf_range(room1.position.x + 1, room1.position.x + room1.size.x + 1)),
			floor(rng.randf_range(room1.position.y + 1, room1.position.y + room1.size.y + 1)))
		var point2 = Vector2(
			floor(rng.randf_range(room2.position.x + 1, room2.position.x + room2.size.x + 1)),
			floor(rng.randf_range(room2.position.y + 1, room2.position.y + room2.size.y + 1)))
		var width = point2.x - point1.x
		var height = point2.y - point1.y
		
		if width < 0:
			if height < 0:
				if rng.randf() < 0.5:
					halls.append(Rect2(point2.x, point1.y, abs(width), 1))
					halls.append(Rect2(point2.x, point2.y, 1, abs(height)))
				else:
					halls.append(Rect2(point2.x, point2.y, abs(width), 1))
					halls.append(Rect2(point1.x, point2.y, 1, abs(height)))
			elif height > 0:
				if rng.randf() < 0.5:
					halls.append(Rect2(point2.x, point1.y, abs(width), 1))
					halls.append(Rect2(point2.x, point2.y, 1, abs(height)))
				else:
					halls.append(Rect2(point2.x, point2.y, abs(width), 1))
					halls.append(Rect2(point1.x, point1.y, 1, abs(height)))
			else:
				halls.append(Rect2(point2.x, point2.y, abs(width), 1))
		elif width > 0:
			if height < 0:
				if rng.randf() < 0.5:
					halls.append(Rect2(point1.x, point2.y, abs(width), 1))
					halls.append(Rect2(point1.x, point2.y, 1, abs(height)))
				else:
					halls.append(Rect2(point1.x, point1.y, abs(width), 1))
					halls.append(Rect2(point2.x, point2.y, 1, abs(height)))
			elif height > 0:
				if rng.randf() < 0.5:
					halls.append(Rect2(point1.x, point1.y, abs(width), 1))
					halls.append(Rect2(point2.x, point1.y, 1, abs(height)))
				else:
					halls.append(Rect2(point1.x, point2.y, abs(width), 1))
					halls.append(Rect2(point1.x, point1.y, 1, abs(height)))
			else:
				halls.append(Rect2(point1.x, point1.y, abs(width), 1))
		else:
			if height < 0:
				halls.append(Rect2(point2.x, point2.y, 1, abs(height)))
			if height > 0:
				halls.append(Rect2(point1.x, point1.y, abs(width), 1))

func gen_rooms() -> Array:
	var max_leaf_size = 20.0
	var bsp_nodes = []
	var root = BSPNode.new(Vector2(), board_size)
	bsp_nodes.append(root)
	var did_split = true
	while did_split:
		did_split = false
		for node in bsp_nodes:
			if node.left != null or node.right != null:
				continue
			if node.size.x <= max_leaf_size and node.size.y <= max_leaf_size:
				continue
			if node.split():
				bsp_nodes.append(node.left)
				bsp_nodes.append(node.right)
				did_split = true
	root.create_rooms()
	return bsp_nodes

func _ready() -> void:
	_grid = _init_grid(board_size)
	_init_map()
	_shadow_mapper.init(self)

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
	return result


func _init_map():
	var nodes = gen_rooms()
	for node in nodes:
		var room = node.room
		var halls = node.halls
		if room:
			fill_rect(room, globals.CELL_TYPES.FLOOR)
		if halls:
			for hall in halls:
				if Rect2(Vector2(), board_size).encloses(hall):
					fill_rect(hall, globals.CELL_TYPES.FLOOR)

func fill_rect(region: Rect2, cell_type: int) -> void:
	for x in range(region.position.x, region.position.x + region.size.x):
		for y in range(region.position.y, region.position.y + region.size.y):
			var region_pos = Vector2(x, y)
			get_tile_at_map_pos(region_pos).set_is_wall(false)
			set_cellv(region_pos, cell_type)

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
	
	if !get_tile_at_map_pos(cell_target).is_wall:
		return update_entity_position(entity, cell_start, cell_target)
	return Vector2()


func update_entity_position(entity: Entity, cell_start : Vector2, cell_target : Vector2) -> Vector2:
	return map_to_world(cell_target) + (cell_size / 2)


func add_entity(entity: Entity, pos: Vector2) -> Vector2:
	return map_to_world(pos) + cell_size / 2


func contains(map_pos: Vector2) -> bool:
	return map_pos.x >= 0 and map_pos.y >= 0 and map_pos.x < board_size.x and map_pos.y < board_size.y


func get_visible_tiles() -> Array:
	return _tile_visibility_painter.get_used_cells_by_id(globals.MASK_CELL_TYPES.EMPTY)

func is_wall(map_pos: Vector2) -> bool:
	var cell_type = get_cellv(map_pos)
	return get_tile_at_map_pos(map_pos).is_wall
	#return cell_type != globals.CELL_TYPES.EMPTY && cell_type != globals.CELL_TYPES.OBJECT


func mark_tile_visible(tile_map_pos: Vector2) -> void:
	var tile = get_tile_at_map_pos(tile_map_pos)
	tile.set_is_visible(true)

func mark_tile_invisible(tile_map_pos: Vector2) -> void:
	var tile = get_tile_at_map_pos(tile_map_pos)
	tile.set_is_visible(false)
