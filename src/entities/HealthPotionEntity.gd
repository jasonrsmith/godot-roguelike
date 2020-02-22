extends PotionEntity
class_name HealthPotionEntity

export var heal_hp : int

func use(entity: ActorEntity, target = null) -> void:
	entity.heal(heal_hp, self)
	remove()
