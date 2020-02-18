extends Node2D
class_name HealParticles

onready var _particles : Particles2D = $Particles2D

func _ready() -> void:
	run_once()
	pass

func run_once() -> void:
	_particles.set_emitting(true)
	print_debug("here")
	yield(get_tree().create_timer(1.0), "timeout")
	print_debug("after timer")
	queue_free()
