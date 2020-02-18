extends PotionEntity
class_name HealthPotionEntity

export var heal_hp : int

func _ready():
	pass # Replace with function body.

func use(entity: ActorEntity):
	entity.heal(heal_hp, self)
	remove()
