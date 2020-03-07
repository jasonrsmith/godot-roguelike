extends StatusEffect
class_name SlowedStatusEffect

export var slowed_rate : float = 0.1

var _original_speed

func init(entity) -> void:
	.init(entity)
	_original_speed = _entity.speed
	_entity.speed = _entity.speed * slowed_rate
	globals.console.print_line("%s is now slowed." % _entity.display_name)

func _execute_action() -> void:
	pass

func expire() -> void:
	_entity.speed = _original_speed
	globals.console.print_line("%s is no longer slowed." % _entity.display_name)
	.expire()
