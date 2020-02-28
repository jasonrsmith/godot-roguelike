extends Node2D
class_name FieldOfView

# based on http://journal.stuffwithstuff.com/2015/09/07/what-the-hero-sees/

var _shadows : Array
var _tiles_in_view = {}
var _board : Board

class ShadowLine:
	var _shadows : Array = []

	func is_in_shadow(projection: Shadow) -> bool:
		for shadow in _shadows:
			if shadow.contains(projection):
				return true
		return false

	# add shadow to list of non-overlapping shadows
	# may merge one or more shadows
	func add(shadow: Shadow):
		var index = 0

		# stop at intersection point
		for s in _shadows:
			if s.start >= shadow.start:
				break
			index += 1

		# create new shadow, check if overlaps with previous
		var overlapping_previous : Shadow
		if index > 0 and _shadows[index - 1].end > shadow.start:
			overlapping_previous = _shadows[index - 1]

		var overlapping_next : Shadow
		if index < _shadows.size() and _shadows[index].start < shadow.end:
			overlapping_next = _shadows[index]

		# insert and merge with overlapping shadows
		if overlapping_next:
			if overlapping_previous:
				overlapping_previous.end = overlapping_next.end
				overlapping_previous.endPos
				_shadows.remove(index)
			else:
				overlapping_next.start = shadow.start
				overlapping_next.startPos = shadow.startPos
		else:
			if overlapping_previous:
				overlapping_previous.end = shadow.end
				overlapping_previous.endPos = shadow.endPos
			else:
				_shadows.insert(index, shadow)

	func is_full_shadow() -> bool:
		return _shadows.size() == 1 and _shadows[0].start == 0 and _shadows[0].end == 1

class Shadow:
	var start : float
	var end : float
	var startPos : Vector2
	var endPos : Vector2

	func _init(start, end, startPos, endPos):
		self.start = start
		self.end = end
		self.startPos = startPos
		self.endPos = endPos

	func contains(other: Shadow):
		return start <= other.start and end >= other.end

	static func project_tile(row: int, col: int) -> Shadow:
		var rowf : float = float(row)
		var colf : float = float(col)
		var top_left : float = colf / (rowf + 2)
		var bottom_right : float = (colf + 1) / (rowf + 1)
		return Shadow.new(top_left, bottom_right, Vector2(col, row + 2), Vector2(col + 1, row + 1))

func _init(board: Board):
	_board = board

func transform_octant(row: int, col: int, octant: int) -> Vector2:
	match octant:
		0:
			return Vector2(col, -row)
		1:
			return Vector2(row, -col)
		2:
			return Vector2(row, col)
		3:
			return Vector2(col, row)
		4:
			return Vector2(-col, row)
		5:
			return Vector2(-row, col)
		6:
			return Vector2(-row, -col)
		7:
			return Vector2(-col, -row)
	assert(false, "unreachble")
	return Vector2()

func get_tiles_in_view() -> Dictionary:
	return _tiles_in_view

func refresh(map_pos: Vector2, distance: int) -> Dictionary:
	_tiles_in_view = {map_pos: true}
	for octant in range(8):
		var seen_in_octant : Dictionary = _refresh_octant(map_pos, distance, _board, octant)
		for x in seen_in_octant:
			_tiles_in_view[x] = true
	return _tiles_in_view

func in_fov(map_pos: Vector2) -> bool:
	return _tiles_in_view.has(map_pos)

func _refresh_octant(map_pos: Vector2, distance, board, octant: int) -> Dictionary:
	var line = ShadowLine.new()
	var full_shadow = false
	var seen = {}

	for row in range(1, distance):
		if not board.contains(map_pos + transform_octant(row, 0, octant)):
			return seen
		for col in range(0, row + 1):
			var tile_pos = map_pos + transform_octant(row, col, octant)
			if not board.contains(tile_pos):
				break
			if full_shadow:
				continue
			else:
				var projection = Shadow.project_tile(row, col)
				var is_visible = !line.is_in_shadow(projection)
				if is_visible:
					if board.is_wall(tile_pos):
						line.add(projection)
						full_shadow = line.is_full_shadow()
					seen[tile_pos] = true
	_shadows = line._shadows
	return seen
