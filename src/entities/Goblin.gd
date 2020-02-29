extends NPCEntity
class_name Goblin

onready var _run_animation = $Pivot/Run/AnimationPlayer
onready var _run_sprite = $Pivot/Run

func move_to_map_pos(target_map_pos: Vector2) -> void:
	_run_sprite.show()
	sprite.hide()
	.move_to_map_pos(target_map_pos)
	_run_sprite.set_flip_h(sprite.flip_h)
	_run_animation.play("run")
	yield(_run_animation, "animation_finished")
	sprite.show()
	_run_sprite.hide()

