extends Entity
class_name ScrollEntity

var use_verb_second_person = "read"
var use_verb_third = "reads"

func _ready() -> void:
	pass

func use(entity: Entity) -> void:
	assert(false, "override me")
