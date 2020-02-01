extends Node2D
class_name ShadowMapper

enum Side {LEFT, RIGHT, TOP, BOTTOM}
enum Direction {LEFT, RIGHT, UP, DOWN}

export (bool) var shadows_enabled = true

var draw_polygons = []

var _board

func init(board: TileMap) -> void:
	add_occluders_from_board(board)


func add_occluders_from_board(board: Board) -> void:
	_board = board
	var occ_polygons : Array = get_occlusion_polygons_for_world()
	for poly in occ_polygons:
		var occ = LightOccluder2D.new()
		occ.set_occluder_polygon(poly)
		add_child(occ)


func _draw():
	for poly in draw_polygons:
		draw_polygon(PoolVector2Array(poly), PoolColorArray([Color(1.0, 0.0, 0.0, 0.5)]))

func get_occlusion_polygons_for_world() -> Array:
	if (!shadows_enabled):
		return []
		
	var map_polygons : Array = get_polygons_to_occlude_for_map()
	var occ_polygons : Array = []
	for map_poly in map_polygons:
		var world_poly_vertices = find_vertices_for_polygon(map_poly)
		#draw_polygons.append(world_poly_vertices)
		var occ_poly = OccluderPolygon2D.new()
		occ_poly.set_polygon(PoolVector2Array(world_poly_vertices))
		occ_poly.set_cull_mode(OccluderPolygon2D.CULL_CLOCKWISE)
		occ_polygons.append(occ_poly)
	return occ_polygons


func get_polygons_to_occlude_for_map() -> Array:
	var occlusion_points : Array = _board.get_used_cells_by_id(1)
	var polygons : Array = get_merged_polygons(occlusion_points)
	return polygons


func get_merged_polygons(points: Array) -> Array:
	var polygons = Array()
	var idx = {}
	for point in points:
		var poly_id : int
		if not point in idx:
			poly_id = polygons.size()
			idx[point] = poly_id
			polygons.append([point])
		else:
			poly_id = idx[point]
		var point_right = Vector2(point.x + 1, point.y)
		var point_down = Vector2(point.x, point.y + 1)

		if _board.get_cellv(point_right) == 1:
			if not point_right in idx:
				idx[point_right] = poly_id
				polygons[poly_id].append(point_right)
		if _board.get_cellv(point_down) == 1:
			if not point_down in idx:
				idx[point_down] = poly_id
				polygons[poly_id].append(point_down)

	return polygons


func upper_left(p: Vector2) -> Vector2:
	return _board.map_to_world(p)


func lower_left(p: Vector2) -> Vector2:
	var wp = _board.map_to_world(p)
	wp.y = wp.y + _board.cell_size.y
	return wp


func upper_right(p: Vector2) -> Vector2:
	var wp = _board.map_to_world(p)
	wp.x = wp.x + _board.cell_size.x
	return wp



func lower_right(p: Vector2) -> Vector2:
	return _board.map_to_world(p) + _board.cell_size


func vector2_xysort(a: Vector2, b: Vector2) -> bool:
	if a.y == b.y:
		return a.x < b.x
	else:
		return a.y < b.y


func find_vertices_for_polygon(map_points: Array) -> Array:
	if len(map_points) == 0:
		return []
	var idx = {}
	for point in map_points:
		idx[point] = true
	var vertices = [
		lower_left(map_points[0]),
		upper_left(map_points[0]),
		upper_right(map_points[0]),
		]
	var seen = {}
	for vertex in vertices:
		seen[vertex] = 1
	var side = Side.TOP
	var direction = Direction.RIGHT
	var cursor = map_points[0]
	var vertex: Vector2
	while true:
		# 1/8
		if side == Side.TOP and direction == Direction.RIGHT:
			if Vector2(cursor.x + 1, cursor.y - 1) in idx:
				cursor = Vector2(cursor.x + 1, cursor.y - 1)
				vertex = upper_left(cursor)
				side = Side.LEFT
				direction = Direction.UP
			elif Vector2(cursor.x + 1, cursor.y) in idx:
				cursor = Vector2(cursor.x + 1, cursor.y)
				vertex = upper_right(cursor)
			else:
				vertex = lower_right(cursor)
				side = Side.RIGHT
				direction = Direction.DOWN
		# 2/8
		elif side == Side.RIGHT and direction == Direction.DOWN:
			if Vector2(cursor.x + 1, cursor.y + 1) in idx:
				cursor = Vector2(cursor.x + 1, cursor.y + 1)
				vertex = upper_right(cursor)
				side = Side.TOP
				direction = Direction.RIGHT
			elif Vector2(cursor.x, cursor.y + 1) in idx:
				cursor = Vector2(cursor.x, cursor.y + 1)
				vertex = lower_right(cursor)
			else:
				vertex = lower_left(cursor)
				side = Side.BOTTOM
				direction = Direction.LEFT
		# 3/8
		elif side == Side.BOTTOM and direction == Direction.LEFT:
			if Vector2(cursor.x - 1, cursor.y + 1) in idx:
				cursor = Vector2(cursor.x - 1, cursor.y + 1)
				vertex = lower_right(cursor)
				side = Side.RIGHT
				direction = Direction.DOWN
			elif Vector2(cursor.x - 1, cursor.y) in idx:
				cursor = Vector2(cursor.x - 1, cursor.y)
				vertex = lower_left(cursor)
			else:
				vertex = upper_left(cursor)
				side = Side.LEFT
				direction = Direction.UP
		if vertex in seen:
			break
		seen[vertex] = 1
		vertices.append(vertex)
	return vertices
