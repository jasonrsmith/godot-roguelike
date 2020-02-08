extends Position2D

var _item_idx = {}

func _ready() -> void:
	globals.item_area = self
	events.connect("player_moved", self, "_on_player_moved")
	events.connect("tile_was_seen", self, "_on_tile_was_seen")

func add_item(item: Entity):
	var map_pos : Vector2 = item.get_map_pos()
	if !_item_idx.has(map_pos):
		_item_idx[map_pos] = []
	_item_idx[map_pos].append(item)
	add_child(item)

func get_items_at_map_pos(map_pos: Vector2) -> Entity:
	if _item_idx.has(map_pos):
		return _item_idx[map_pos]
	return null

func _on_player_moved(map_pos: Vector2) -> void:
	var items := get_items_at_map_pos(map_pos)
	if !items:
		return
	for item in items:
		globals.debug_canvas.print_line("You see a " + item.display_name + ". " + item.stats.description)

func _on_tile_was_seen(map_pos: Vector2) -> void:
	var items := get_items_at_map_pos(map_pos)
	if !items:
		return
	for item in items:
		if item:
			item.show()
