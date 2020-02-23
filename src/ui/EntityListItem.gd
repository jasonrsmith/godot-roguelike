tool
extends Button
class_name EntityListItem

onready var _image_box : HBoxContainer = $HBoxContainer
onready var _shortcut : Label = $HBoxContainer/Shortcut
onready var _image : TextureRect = $HBoxContainer/TextureRect
onready var _name : Label = $DisplayName

var _shortcut_hotkey : String

func _ready() -> void:
	connect("resized", self, "_on_resized")

func init(name: String, image: Texture, shortcut = "") -> void:
	if shortcut == "":
		_shortcut.hide()
	else:
		_shortcut_hotkey = shortcut
	_shortcut.set_text(shortcut)
	_name.set_text(name)
	if !image:
		_image.hide()
	else:
		_image.set_texture(image)
	_on_resized()

func _input(event: InputEvent) -> void:
	if event in InputEventKey and _shortcut_hotkey == char(event.scancode+32):
		print_debug("HOTKEY HIT:", char(event.scancode+32))

func _on_resized():
	_name.rect_position = Vector2(_image_box.rect_size.x, _image_box.rect_position.y)
	_name.rect_size = Vector2(rect_size.x - _image_box.rect_size.x, -1.0)
	_name.rect_min_size = Vector2(-1.0, _image_box.rect_size.y)
	rect_min_size = Vector2(0.0, max(_name.rect_size.y, _image_box.rect_size.y))
