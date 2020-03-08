extends Control

onready var _label = $Label
onready var _bar = $TextureProgress

func _ready() -> void:
	pass

func set_value(value: int) -> void:
	_bar.set_value(value)

func set_text(text: String) -> void:
	_label.set_text(text)
