extends CanvasLayer
class_name Console

onready var _label : RichTextLabel = $RichTextLabel

var console_print_enabled : bool = true setget set_console_print_enabled
export (bool) var print_player_info_enabled = true
export (bool) var print_debug_enabled = false

func _ready():
	globals.debug_canvas = self
	_label.clear()
	_label.scroll_following = true
	add_lines()

func add_lines() -> void:
	for i in range(20):
		_label.add_text("\n")

func print_line(s: String, cat=globals.LOG_CAT.PLAYER_INFO) -> void:
	if console_print_enabled:
		print_debug(s)
	match cat:
		globals.LOG_CAT.DEBUG:
			if !print_debug_enabled:
				return
		globals.LOG_CAT.PLAYER_INFO:
			if !print_player_info_enabled:
				return
	_label.add_text("\n")
	_label.add_text(s)

func clear() -> void:
	_label.clear()

func set_console_print_enabled(value: bool) -> void:
	console_print_enabled = value
