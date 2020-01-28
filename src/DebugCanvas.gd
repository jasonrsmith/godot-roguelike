extends CanvasLayer
class_name DebugCanvas

#onready var _scroll_container = $Control/Panel/MarginContainer/ScrollContainer
#onready var _label_container = $Control/Panel/MarginContainer/ScrollContainer/VBoxContainer
onready var _scroll_container = $Control/Panel/ScrollContainer
onready var _label_container = $Control/Panel/ScrollContainer/VBoxContainer

var _label
var console_print_enabled : bool = true setget set_console_print_enabled

func _ready():
	_label = globals.system_label.instance()
	_label.set_text("")
	_label_container.add_child(_label)
	add_lines()

func add_lines() -> void:
	for i in range(5):
		print_line("")

func print_line(s: String) -> void:
	var label: Label = globals.system_label.instance()
	label.set_text(s)
	if console_print_enabled:
		print_debug(s)
	if _label_container and _label:
		_label_container.add_child(label)
		_scroll_container.set_v_scroll(_label_container.rect_size.y + 100)

func clear() -> void:
	for label in _label_container.get_children():
		label.queue_free()
	add_lines()

func set_console_print_enabled(value: bool) -> void:
	console_print_enabled = value