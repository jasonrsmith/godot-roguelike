extends Entity
class_name FireEntity

export var burn_time_min : int
export var burn_time_max : int
export var percent_chance_to_burn_in_turn : float

onready var _burning = $Burning

func _ready() -> void:
	_offset_burning_animation()

func _offset_burning_animation() -> void:
	_burning.set_material(_burning.get_material().duplicate())
	_burning.get_material().set_shader_param("time_offset", globals.rng.randf_range(0.0, 5.0))
