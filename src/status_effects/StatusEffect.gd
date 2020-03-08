extends Node2D
class_name StatusEffect

export var display_name : String
export var duration_per_turn : int = 100
export var max_turns : int = 1

var turns_taken := 0

var _entity
var _action_points : int


func _ready() -> void:
	pass

# TODO: cyclic reference on entity
func init(entity) -> void:
	_entity = entity
	_action_points = duration_per_turn

func run_for_action_points(action_points: int) -> bool:
	"""
	returns true if not expired
	"""
	_action_points -= action_points
	if _action_points <= 0:
		turns_taken += 1
		_action_points += duration_per_turn
		_execute_action()
		if turns_taken == max_turns:
			expire()
			return false
	return true

func _execute_action() -> void:
	pass

func expire() -> void:
	queue_free()
