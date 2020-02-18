extends PotionEntity
class_name HealthPotionEntity

export var heal_hp : int

func _ready():
	pass # Replace with function body.

func use(entity: ActorEntity) -> void:
	#fx.set_position(entity.get_position())
	#add_child(fx)
	entity.heal(heal_hp, self)
	remove()
