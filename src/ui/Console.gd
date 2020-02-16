extends RichTextLabel
class_name Console

var console_print_enabled : bool = true setget set_console_print_enabled
export (bool) var print_player_info_enabled = true
export (bool) var print_debug_enabled = false

func _ready():
	globals.console = self
	clear()
	scroll_following = true
	add_lines()

func add_lines() -> void:
	for i in range(20):
		add_text("\n")

func print_line(s: String, cat=globals.LOG_CAT.PLAYER_INFO) -> void:
	if console_print_enabled:
		print_debug(s)
	var color = "gray"
	match cat:
		globals.LOG_CAT.DEBUG:
			if !print_debug_enabled:
				return
		globals.LOG_CAT.ERROR:
			color = "red"
		globals.LOG_CAT.CRITICAL:
			color = "red"
		globals.LOG_CAT.PLAYER_INFO:
			color = "white"
			if !print_player_info_enabled:
				return
	add_text("\n")
	append_bbcode("[color={color}]{string}[/color]".format({ "color": color, "string": s}))

func set_console_print_enabled(value: bool) -> void:
	console_print_enabled = value
