extends PanelContainer

onready var _label : Label = $MarginContainer/Label
onready var _min_size : Vector2 = rect_size

var entity

func set_entity(e):
	entity = e
	_label.set_text(entity.display_name)

func _input(event):
	if event is InputEventMouseMotion:
		var world_pos = globals.camera.get_global_mouse_position()
		var parent : CanvasLayer = get_parent()
		var mouse_entity = (globals.board.get_entity_at(
			globals.board.world_to_map(world_pos)))
		if !entity or mouse_entity != entity:
			self.hide()
			return
		parent.scale = globals.camera.zoom
		var adjusted_global_pos : Vector2 = entity.global_position / globals.camera.zoom
		var adjusted_offset_x = globals.map_cell_size / 1.5 / globals.camera.zoom.x
		self.rect_position = Vector2(
			adjusted_global_pos.x - self.rect_size.x - adjusted_offset_x,
			adjusted_global_pos.y - globals.map_cell_size / 2)
		self.show()
	else:
		self.hide()
