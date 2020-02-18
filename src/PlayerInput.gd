extends Node
class_name PlayerInput

var _entity : Entity
var _direction : Vector2

onready var _timer : Timer = $Timer

func _ready() -> void:
	globals.player_input = self

func initialize(entity : Entity) -> void:
	_entity = entity

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
	
	if event.is_action_pressed("ui_wait"):
		print_debug("player sees wait")
		globals.player_entity.set_action(
			globals.player_entity.ACTION.WAIT)
		events.emit_signal("player_acted")
		return
	
	if event.is_action_pressed("ui_drop"):
		#globals.ui.show_drop_screen()
		return
	
	if event.is_action_pressed("ui_show_inventory"):
		globals.character_info_modal.show_inventory()
		return
	
	_direction = get_key_input_direction(event)
	if _direction != Vector2():
		globals.player_entity.set_action(
			globals.player_entity.ACTION.MOVE_OR_ATTACK,
			{"direction": _direction})
		events.emit_signal("player_acted")
		_direction = Vector2()
