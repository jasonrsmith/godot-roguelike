extends Node
class_name PlayerInput

var _board : Board
var _entity : Entity
var _direction : = Vector2()

onready var _timer : Timer = $Timer

func initialize(entity : Entity, board : Board) -> void:
	_entity = entity
	_board = board


func _process(delta: float) -> void:
	if _direction == Vector2():
		return
	var target_pos : Vector2 = _board.request_move(_entity, _direction)
	if target_pos:
		#_entity.move_in_direction(_direction)
		_entity.move_to(target_pos)
		events.emit_signal("player_moved", target_pos)
	else:
		_entity.bump()
	_direction = Vector2()


func get_key_input_direction(event: InputEventKey) -> Vector2:
	var dir = Vector2(
		int(event.is_action_pressed("ui_right")) - int(event.is_action_pressed("ui_left")),
		int(event.is_action_pressed("ui_down")) - int(event.is_action_pressed("ui_up"))
	)
	if dir != _direction:
		_timer.start(0.3)
		return dir
	if !_timer.is_stopped():
		return Vector2()
	_timer.start(0.03)
	return Vector2(
		int(event.is_action("ui_right")) - int(event.is_action("ui_left")),
		int(event.is_action("ui_down")) - int(event.is_action("ui_up"))
	)


func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	_direction = get_key_input_direction(event)