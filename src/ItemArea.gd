extends Position2D
class_name ItemArea

var _item_idx = {}

func _ready() -> void:
	globals.item_area = self
	events.connect("tile_was_seen", self, "_on_tile_was_seen")

func add_item(item: Entity):
	var map_pos : Vector2 = item.get_map_pos()
	assert(!_item_idx.has(map_pos))
	_item_idx[map_pos] = item
	add_child(item)
	events.emit_signal("entity_added_to_map", item)
	if globals.debug_settings.disable_entity_hiding or globals.player_entity.is_tile_visible(item.get_map_pos()):
		item.show()
	else:
		item.hide()

func get_item_at_map_pos(map_pos: Vector2) -> Entity:
	if _item_idx.has(map_pos):
		return _item_idx[map_pos]
	return null

func remove_item(item: Entity) -> void:
	var map_pos = item.get_map_pos()
	assert(_item_idx.has(map_pos))
	_item_idx.erase(map_pos)

func _on_tile_was_seen(map_pos: Vector2) -> void:
	var item := get_item_at_map_pos(map_pos)
	if !item:
		return
	item.show()
