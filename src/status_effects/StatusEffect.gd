extends Node2D
class_name StatusEffect

signal expired

export var display_name : String
export var duration : int

var _entity : Entity
var _action_points: int

func _ready() -> void:
	pass

func init(entity: Entity) -> void:
	_entity = entity
	_action_points = duration

func run_for_action_points(action_points: int) -> void:
	_action_points -= action_points
	if _action_points <= 0:
		expire()

func expire() -> void:
	emit_signal("expired")
	free()
