extends Sprite
class_name HitEffect

onready var _animation_player : AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	pass # Replace with function body.

func run_once() -> void:
	show()
	_animation_player.play("slash")
	yield(_animation_player, "animation_finished")
	hide()
