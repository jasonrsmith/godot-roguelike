extends Node2D
class_name BSP

const MIN_SIZE = 10.0
const MAX_SIZE = 30.0


class BSPNode:
	var map_pos: Vector2
	var size: Vector2
	var left: BSPNode
	var right: BSPNode

	var room: Rect2
	var halls : Array
	
	var rng: RandomNumberGenerator

	func _init(boundary: Rect2) -> void:
		self.map_pos = boundary.position
		self.size = boundary.size
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
			left = BSPNode.new(Rect2(map_pos, Vector2(size.x, split_pos)))
			right = BSPNode.new(Rect2(
				Vector2(map_pos.x, map_pos.y + split_pos),
				Vector2(size.x, size.y - split_pos)))
		else:
			left = BSPNode.new(Rect2(map_pos, Vector2(split_pos, size.y)))
			right = BSPNode.new(Rect2(
				Vector2(map_pos.x + split_pos, map_pos.y),
				Vector2(size.x - split_pos, size.y)))
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
			round(rng.randf_range(room1.position.x + 1, room1.position.x + room1.size.x - 2)),
			round(rng.randf_range(room1.position.y + 1, room1.position.y + room1.size.y - 2)))
		var point2 = Vector2(
			round(rng.randf_range(room2.position.x + 1, room2.position.x + room2.size.x - 2)),
			round(rng.randf_range(room2.position.y + 1, room2.position.y + room2.size.y - 2)))
		var width = point2.x - point1.x
		var height = point2.y - point1.y
		
		if width < 0:
			if height < 0:
				if rng.randf() < 0.5:
					halls.append(Rect2(point2.x, point1.y, abs(width), 1))
					halls.append(Rect2(point2.x, point2.y, 1, abs(height) + 1))
				else:
					halls.append(Rect2(point2.x, point2.y, abs(width), 1))
					halls.append(Rect2(point1.x, point2.y, 1, abs(height) + 1))
			elif height > 0:
				if rng.randf() < 0.5:
					halls.append(Rect2(point2.x, point1.y, abs(width), 1))
					halls.append(Rect2(point2.x, point1.y, 1, abs(height) + 1))
				else:
					halls.append(Rect2(point2.x, point2.y, abs(width), 1))
					halls.append(Rect2(point1.x, point1.y, 1, abs(height) + 1))
			else:
				halls.append(Rect2(point2.x, point2.y, abs(width), 1))
		elif width > 0:
			if height < 0:
				if rng.randf() < 0.5:
					halls.append(Rect2(point1.x, point2.y, abs(width), 1))
					halls.append(Rect2(point1.x, point2.y, 1, abs(height) + 1))
				else:
					halls.append(Rect2(point1.x, point1.y, abs(width), 1))
					halls.append(Rect2(point2.x, point2.y, 1, abs(height) + 1))
			elif height > 0:
				if rng.randf() < 0.5:
					halls.append(Rect2(point1.x, point1.y, abs(width), 1))
					halls.append(Rect2(point2.x, point1.y, 1, abs(height) + 1))
				else:
					halls.append(Rect2(point1.x, point2.y, abs(width), 1))
					halls.append(Rect2(point1.x, point1.y, 1, abs(height) + 1))
			else:
				halls.append(Rect2(point1.x, point1.y, abs(width), 1))
		else:
			if height < 0:
				halls.append(Rect2(point2.x, point2.y, 1, abs(height)))
			if height > 0:
				halls.append(Rect2(point1.x, point1.y, 1, abs(height)))

func gen_rooms(boundary: Rect2) -> Array:

	var bsp_nodes = []
	var root = BSPNode.new(boundary)
	bsp_nodes.append(root)
	var did_split = true
	while did_split:
		did_split = false
		for node in bsp_nodes:
			if node.left != null or node.right != null:
				continue
			if node.size.x <= MAX_SIZE and node.size.y <= MAX_SIZE:
				continue
			if node.split():
				bsp_nodes.append(node.left)
				bsp_nodes.append(node.right)
				did_split = true
	root.create_rooms()
	return bsp_nodes
