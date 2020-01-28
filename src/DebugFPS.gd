extends DebugCanvas
class_name DebugFPS

func _ready():
	.set_console_print_enabled(false)

func _process(delta) -> void:
	clear()
	print_line(str(Engine.get_frames_per_second()))
