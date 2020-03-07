extends ScrollEntity
class_name LethargyScrollEntity

export var max_range : int = 20

const LethargicStatusEffect = preload("res://src/status_effects/SlowedStatusEffect.tscn")

func use(entity: Entity, target_entity = null) -> void:
	if !target_entity:
		globals.console.print_line("There's nothing you can target.  You lose the scroll and feel very foolish.  You contemplate giving up the adventuring lifestyle for good, learning computer programming, and getting a high-paying job in tech.")
		return
	var effect := LethargicStatusEffect.instance()
	target_entity.add_status_effect(effect)

func use_on(entity: Entity, target_entity: Entity) -> void:
	use(entity, target_entity)
