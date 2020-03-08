tool
extends Button
class_name ListItem

# MarginContainers allow us to push the shortcut text and name text down
# just far enough (~5px) to be centered with the Image.
onready var _shortcut_margin : MarginContainer = $VBox/HBox/ShortcutMargin
onready var _shortcut : Label = $VBox/HBox/ShortcutMargin/Shortcut
onready var _image_margin : TextureRect = $VBox/HBox/ImageMargin
onready var _image : TextureRect = $VBox/HBox/ImageMargin/Image
onready var _name_margin : MarginContainer = $VBox/HBox/NameMargin
onready var _name : Label = $VBox/HBox/NameMargin/Name

var _shortcut_hotkey : String

func init(description: String, image = null, shortcut = "") -> void:
	if shortcut == "":
		_shortcut.hide()
		_shortcut_margin.hide()
	else:
		_shortcut_hotkey = shortcut
	_shortcut.set_text(shortcut)
	_name.set_text(description)
	if !image:
		_image.hide()
		_image_margin.hide()
	else:
		_image.set_texture(image)
	_name.connect("resized", self, "_on_name_resized")

func _input(event: InputEvent) -> void:
	if event in InputEventKey and _shortcut_hotkey == char(event.scancode+32):
		print_debug("HOTKEY HIT:", char(event.scancode+32))

func _on_name_resized():
	"""
	The item's new size is not updated by godot until after the next draw
	cycle, so we defer size calculations to the _after_name_resized func.
	"""
	call_deferred("_after_name_resized")

func _after_name_resized():
	"""
	Calculates the height of _name Label and updates minimum sizes accordingly.
	"""
	var name_height = _name.get_line_count() * (
		_name.get_line_height() + _name.get_constant("line_spacing")
	)
	var max_child_height = _calculate_child_height()
	_name.set_custom_minimum_size(Vector2(0.0, name_height))
	set_custom_minimum_size(Vector2(0.0, max_child_height))

func _calculate_child_height() -> float:
	var name_height = _name.get_line_count() * (
		_name.get_line_height() + _name.get_constant("line_spacing")
	)
	var name_margin_height = (
		name_height +
		_name_margin.get_constant("margin_top") +
		_name_margin.get_constant("margin_bottom")
	)
	var image_margin_height = (
		_image.rect_size.y +
		_image_margin.get_constant("margin_top") +
		_image_margin.get_constant("margin_bottom")
	)
	return max(name_margin_height, image_margin_height)
