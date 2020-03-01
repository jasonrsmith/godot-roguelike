extends NPCEntity
class_name Goblin

onready var _attack_animation = $Pivot/Attack/AnimationPlayer
onready var _attack_sprite = $Pivot/Attack
onready var _run_animation = $Pivot/Run/AnimationPlayer
onready var _run_sprite = $Pivot/Run
onready var _death_animation = $Pivot/Death/AnimationPlayer
onready var _death_sprite = $Pivot/Death

func move_to_map_pos(target_map_pos: Vector2) -> void:
	.move_to_map_pos(target_map_pos)
	_run_sprite.show()
	sprite.hide()
	_run_sprite.set_flip_h(sprite.flip_h)
	_run_animation.play("run")
	yield(_run_animation, "animation_finished")
	sprite.show()
	_run_sprite.hide()

func execute_attack(entity: Entity):
	.execute_attack(entity)
	_attack_sprite.show()
	sprite.hide()
	_attack_sprite.set_flip_v(sprite.flip_h)
	_attack_sprite.rotation_degrees = 180 if sprite.flip_h else 0
	_attack_animation.play("run")
	yield(_attack_animation, "animation_finished")
	sprite.show()
	_attack_sprite.hide()

func _show_death() -> void:
	_death_sprite.show()
	sprite.hide()
	_death_sprite.set_flip_h(sprite.flip_h)
	_death_animation.play("run")
	yield(_death_animation, "animation_finished")
