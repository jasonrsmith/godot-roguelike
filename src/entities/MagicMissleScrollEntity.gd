extends ScrollEntity
class_name MagicMissleScrollEntity

export var damage : int
export var missle_range : int

var _target : Entity

func _ready() -> void:
	pass

func use(entity: Entity) -> void:
	if !_target and entity == globals.player_entity:
		pass
