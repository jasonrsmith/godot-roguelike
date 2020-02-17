# based on http://journal.stuffwithstuff.com/2015/09/07/what-the-hero-sees/

extends Node2D
class_name FOV

var _shadows

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

func _ready() -> void:
	globals.fov = self
	if globals.debug_settings.hide_fov:
		hide()

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
	assert("unreachble")
	return Vector2()


func refresh(map_pos: Vector2) -> void:
	var seen = {}
	seen[map_pos] = true
	globals.board.mark_tile_visible(map_pos)
	for octant in range(8):
		var seen_in_octant : Dictionary = _refresh_octant(map_pos, octant, globals.player_entity.sight)
		for x in seen_in_octant:
			seen[x] = true
	for tile in globals.board.get_visible_tiles():
		if not seen.has(tile):
			globals.board.mark_tile_invisible(tile)


func _refresh_octant(map_pos: Vector2, octant: int, max_map_distance=12) -> Dictionary:
	var line = ShadowLine.new()
	var full_shadow = false
	var seen = {}
	
	for row in range(1, max_map_distance):
		if not globals.board.contains(map_pos + transform_octant(row, 0, octant)):
			return seen
		for col in range(0, row + 1):
			var tile_pos = map_pos + transform_octant(row, col, octant)

			if not globals.board.contains(tile_pos):
				break
			if full_shadow:
				globals.board.mark_tile_invisible(tile_pos)
			else:
				var projection = Shadow.project_tile(row, col)
				var is_visible = !line.is_in_shadow(projection)
				if is_visible:
					globals.board.mark_tile_visible(tile_pos)
					if globals.board.is_wall(tile_pos):
						line.add(projection)
						full_shadow = line.is_full_shadow()
					seen[tile_pos] = true
				else:
					globals.board.mark_tile_invisible(tile_pos)
	_shadows = line._shadows
	update()
	return seen

func _on_player_moved(map_pos: Vector2) -> void:
	refresh(map_pos)

func _draw():
	var line_width = 9
	if !_shadows:
		return
	for shadow in _shadows:
		pass
		#var left = shadow.start * shadow.start * line_width + 
