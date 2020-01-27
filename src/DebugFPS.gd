extends DebugCanvas
class_name DebugFPS

func _process(delta) -> void:
	clear()
	print_line(str(Engine.get_frames_per_second()))
