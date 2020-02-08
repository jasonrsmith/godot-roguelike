extends Position2D

var _item_idx = {}

func _ready() -> void:
	globals.item_area = self
	events.connect("player_moved", self, "_on_player_moved")

func add_item(item: Entity):
	var map_pos : Vector2 = item.get_map_pos()
	assert(!_item_idx.has(map_pos))
	_item_idx[map_pos] = item
	add_child(item)

func get_item(map_pos: Vector2) -> Entity:
	if _item_idx.has(map_pos):
		return _item_idx[map_pos]
	return null

func _on_player_moved(map_pos: Vector2) -> void:
	var item := get_item(map_pos)
	if item:
		globals.debug_canvas.print_line("You see a " + item.display_name + ". " + item.stats.description)
