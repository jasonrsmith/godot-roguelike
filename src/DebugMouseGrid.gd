extends DebugCanvas
class_name DebugMouseGrid

func _input(event):
	if event is InputEventMouseMotion:
		clear()
		#print_line("(" + str(event.position.x) + ", " +  str(event.position.y))
		var world_pos = globals.camera.get_global_mouse_position()
		print_line(str(world_pos))
		print_line(str(globals.board.world_to_map(world_pos)))