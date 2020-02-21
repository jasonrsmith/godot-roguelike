extends Button
class_name EntityListItem

onready var _shortcut : Label = $HBoxContainer/Shortcut
onready var _image : TextureRect = $HBoxContainer/TextureRect
onready var _name : Label = $HBoxContainer/DisplayName

var _shortcut_hotkey : String

func _ready() -> void:
	pass # Replace with function body.

func init(shortcut: String, name: String, image: Texture) -> void:
	_shortcut_hotkey = shortcut
	_shortcut.set_text(shortcut)
	_name.set_text(name)
	if !image:
		_image.hide()
	else:
		_image.set_texture(image)

func _input(event: InputEvent) -> void:
	if event in InputEventKey and _shortcut_hotkey == char(event.scancode+32):
		print_debug("HOTKEY HIT:", char(event.scancode+32))
