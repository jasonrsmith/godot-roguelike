extends Node2D
class_name HealParticles

onready var _particles : Particles2D = $Particles2D

func _ready() -> void:
	pass

func run_once() -> void:
	_particles.set_emitting(true)
	#yield(get_tree().create_timer(1.0), "timeout")

