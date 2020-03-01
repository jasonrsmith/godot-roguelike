extends StatusEffect
class_name BurningStatusEffect

export var damage : int = 5

func _execute_action() -> void:
	var hit : Hit = Hit.new(damage)
	_entity.take_damage(hit, self)

func expire() -> void:
	.expire()
