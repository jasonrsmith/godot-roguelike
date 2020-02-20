extends Area2D

export var speed : int = 200
export var steer_force = 3500.0

var _velocity : Vector2 = Vector2()
var _acceleration : Vector2 = Vector2()
var _target : Node2D
onready var _explosion : Particles2D = $Explosion
onready var _sprite : AnimatedSprite = $AnimatedSprite

func _ready() -> void:
	set_physics_process(false)
	connect("body_entered", self, "_on_Missile_body_entered")

func init(target: Node2D) -> void:
	_target = target
	global_rotation = global_position.angle_to_point(target.global_position)
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	_acceleration += _seek()
	_velocity = (_velocity + _acceleration * delta).clamped(speed)
	rotation = _velocity.angle()
	position += _velocity * delta

func _on_Missile_body_entered(body):
	if body:
		if body == _target:
			explode()

func explode() -> void:
	position = _target.position
#	yield(get_tree().create_timer(0.1), "timeout")
	_explosion.set_emitting(true)
	_sprite.hide()
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()

func _on_Lifetime_timeout():
	queue_free()

func _seek() -> Vector2:
	var steer := Vector2()
	if _target:
		var desired = (_target.position - position).normalized() * speed
		steer = (desired - _velocity).normalized() * steer_force
	return steer
