extends Node2D
class_name StatusEffect

export var display_name : String
export var duration_per_turn : int
export var max_turns : int

var _entity
var _action_points : int
var _turns_taken := 0

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
		_turns_taken += 1
		_action_points += duration_per_turn
		_execute_action()
		if _turns_taken == max_turns:
			return false
	return true

func _execute_action() -> void:
	pass
