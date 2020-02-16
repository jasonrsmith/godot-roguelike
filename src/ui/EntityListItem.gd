extends Button
class_name EntityListItem

onready var _shortcut : Label = $HBoxContainer/Shortcut
onready var _image : TextureRect = $HBoxContainer/TextureRect
onready var _name : Label = $HBoxContainer/DisplayName


func _ready() -> void:
	pass # Replace with function body.

func init(shortcut: String, name: String, image: Texture) -> void:
	_shortcut.set_text(shortcut)
	_name.set_text(name)
	if !image:
		_image.hide()
	else:
		_image.set_texture(image)
