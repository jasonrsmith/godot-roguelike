extends PotionEntity
class_name HealthPotionEntity

export var heal_hp : int

func use(entity: ActorEntity) -> void:
	entity.heal(heal_hp, self)
	remove()
