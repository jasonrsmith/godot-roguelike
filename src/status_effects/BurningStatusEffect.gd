extends StatusEffect
class_name BurningStatusEffect

export var damage : int = 5

func process_effect(action_points: int) -> void:
	var hit : Hit = Hit.new(damage)
	_entity.take_damage(hit, self)
	.process_effect(action_points)

func expire() -> void:
	.expire()
