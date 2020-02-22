extends Button
class_name EntityListItem

onready var _shortcut : Label = $HBoxContainer/Shortcut
onready var _image : TextureRect = $HBoxContainer/TextureRect
onready var _name : Label = $HBoxContainer/DisplayName

var _shortcut_hotkey : String

func _ready() -> void:
	pass # Replace with function body.

func init(name: String, image: Texture, shortcut = "") -> void:
	if shortcut != "":
		_shortcut_hotkey = shortcut
	_shortcut.set_text(shortcut)
	_name.set_text(name)
	if !image:
		_image.hide()
	else:
		_image.set_texture(image)

func shorten(width: int) -> void:
	_name.autowrap = true
	_name.rect_min_size.x = width

func _input(event: InputEvent) -> void:
	if event in InputEventKey and _shortcut_hotkey == char(event.scancode+32):
		print_debug("HOTKEY HIT:", char(event.scancode+32))
