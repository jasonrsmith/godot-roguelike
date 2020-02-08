extends PanelContainer

onready var _label : Label = $MarginContainer/Label
onready var _min_size : Vector2 = rect_size

var entity

func set_entity(e):
	entity = e
	_label.set_text(entity.display_name.capitalize())

func _input(event):
	if !event is InputEventMouseMotion or !entity or !entity.is_visible_in_tree():
		self.hide()
		return
	var map_pos : Vector2  = globals.board.get_mouse_map_pos()
	_update_tooltip_visibility_for_map_pos(map_pos)

func _update_tooltip_visibility_for_map_pos(map_pos: Vector2):
	var mouse_monster_entity = globals.board.get_entity_at(map_pos)
	var mouse_item_entities = globals.item_area.get_items_at_map_pos(map_pos)
	var mouse_entity : Entity
	var item_pos := 0
	if mouse_monster_entity == entity:
		mouse_entity = mouse_monster_entity
	if !mouse_entity and mouse_item_entities:
		if mouse_monster_entity:
			item_pos += 1
		for mouse_item_entity in mouse_item_entities:
			if entity == mouse_item_entity:
				mouse_entity = mouse_item_entity
				break
			item_pos += 1
	if !mouse_entity:
		self.hide()
		return
	_scale_for_camera()
	_show_at_pos(item_pos)

func _scale_for_camera() -> void:
	var parent : CanvasLayer = get_parent()
	parent.scale = globals.camera.zoom

func _show_at_pos(pos: int) -> void:
	var adjusted_global_pos : Vector2 = entity.global_position / globals.camera.zoom
	var adjusted_offset_x = globals.map_cell_size / 1.5 / globals.camera.zoom.x
	self.rect_position = Vector2(
		adjusted_global_pos.x - self.rect_size.x - adjusted_offset_x,
		(pos * (globals.map_cell_size + globals.map_cell_size / 2)) + adjusted_global_pos.y - globals.map_cell_size / 2)
	self.show()
