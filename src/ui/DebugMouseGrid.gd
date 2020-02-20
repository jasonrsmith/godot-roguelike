extends Label
class_name DebugMousePos

func _process(delta: float) -> void:
	globals.debug_mouse_pos = self
	if globals.debug_settings.show_mouse_pos:
		show()
	else:
		hide()

func _input(event):
	if event is InputEventMouseMotion:
		var world_pos = globals.camera.get_global_mouse_position()
		var text = str(world_pos.round()) + "\n" + str(globals.board.world_to_map(world_pos))
		set_text(text)
