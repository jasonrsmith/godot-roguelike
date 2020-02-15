extends HBoxContainer
class_name EntityListItem

onready var _shortcut : Label = $Shortcut
onready var _image : TextureRect = $TextureRect
onready var _name : Label = $DisplayName

func _ready() -> void:
	pass # Replace with function body.

func init(shortcut: String, image: Texture, name: String) -> void:
	_shortcut.set_text(shortcut)
	_image.set_texture(image)
	_name.set_text(name)
