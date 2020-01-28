extends DebugCanvas
class_name DebugMouseGrid

func _ready():
	.set_console_print_enabled(false)

func _input(event):
	if event is InputEventMouseMotion:
		clear()
		var world_pos = globals.camera.get_global_mouse_position()
		print_line(str(world_pos.round()))
		print_line(str(globals.board.world_to_map(world_pos)))
