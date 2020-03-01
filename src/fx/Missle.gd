extends Area2D
class_name Missle

signal exploded

export var speed : int = 300
export var steer_force := 3500.0

var _velocity : Vector2 = Vector2()
var _acceleration : Vector2 = Vector2()
var _target : Entity
var _target_position : Vector2
var _has_exploded := false

onready var _explosion : Particles2D = $Explosion
onready var _sprite : AnimatedSprite = $AnimatedSprite
onready var _timer : Timer = $Timer

func _ready() -> void:
	connect("area_entered", self, "_on_Missile_body_entered")
	_timer.connect("timeout", self, "_on_Lifetime_timeout")

func init(target: Entity) -> void:
	_target = target
	_target_position = _target.global_position
	global_rotation = global_position.angle_to_point(_target_position)
	global_rotation += globals.rng.randf_range(-0.9, 0.9)

func _physics_process(delta: float) -> void:
	if _has_exploded:
		return
	_acceleration += _seek()
	_velocity = (_velocity + _acceleration * delta).clamped(speed)
	rotation = _velocity.angle()
	position += _velocity * delta

func _on_Missile_body_entered(body):
	if body and body == _target or body.get_parent() == _target:
		explode()

func explode() -> void:
	if _has_exploded:
		return
	_has_exploded = true
	_explosion.set_emitting(true)
	_sprite.hide()
	emit_signal("exploded")
	yield(get_tree().create_timer(0.25), "timeout")
	queue_free()

func _on_Lifetime_timeout():
	queue_free()

func _seek() -> Vector2:
	var steer := Vector2()
	var desired = (_target_position - position).normalized() * speed
	steer = (desired - _velocity).normalized() * steer_force
	return steer
