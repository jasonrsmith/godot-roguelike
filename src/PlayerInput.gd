extends Node
class_name PlayerInput

var _board : Board
var _entity : Entity
var _direction : Vector2

onready var _timer : Timer = $Timer

func _ready() -> void:
	globals.player_input = self

func initialize(entity : Entity, board : Board) -> void:
	_entity = entity
	_board = board

func run_action(name: String, params: Dictionary):
	var direction:Vector2 = params.direction
	if direction == Vector2():
		return
	if name == "move":
		var target_map_pos : Vector2 = _board.request_move(_entity, direction)
		if target_map_pos:
			_entity.move_to_map_pos(target_map_pos)
			events.emit_signal("player_moved", target_map_pos)
		else:
			_entity.bump()
		_direction = Vector2()
	elif name == "attack":
		var target_entity : Entity = params.entity
		var hit = Hit.new(_entity.stats.strength)
		target_entity.take_damage(hit)


func get_key_input_direction(event: InputEventKey) -> Vector2:
	var dir = Vector2(
		int(event.is_action_pressed("ui_right") or event.is_action_pressed("ui_up_right") or event.is_action_pressed("ui_down_right"))
			- int(event.is_action_pressed("ui_left") or event.is_action_pressed("ui_up_left") or event.is_action_pressed("ui_down_left")),
		int(event.is_action_pressed("ui_down") or event.is_action_pressed("ui_down_right") or event.is_action_pressed("ui_down_left"))
			- int(event.is_action_pressed("ui_up") or event.is_action_pressed("ui_up_right") or event.is_action_pressed("ui_up_left"))
	)
	if dir != _direction:
		_timer.start(0.3)
		return dir
	if !_timer.is_stopped():
		return Vector2()
	_timer.start(0.03)
	return Vector2(
		int(event.is_action("ui_right") or event.is_action("ui_up_right") or event.is_action("ui_down_right"))
			- int(event.is_action("ui_left") or event.is_action("ui_up_left") or event.is_action("ui_down_left")),
		int(event.is_action("ui_down") or event.is_action("ui_down_right") or event.is_action("ui_down_left"))
			- int(event.is_action("ui_up") or event.is_action("ui_up_right") or event.is_action("ui_up_left"))
	)


func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	_direction = get_key_input_direction(event)
	if _direction != Vector2():
		var entity = _board.get_entity_at(
			_board.world_to_map(_entity.position) + _direction)
		if entity:
			State.queue_action(self, 100, "attack", {"direction": _direction, "entity": entity})
		else:
			State.queue_action(self, 100, "move", {"direction": _direction})
		State.unpause()