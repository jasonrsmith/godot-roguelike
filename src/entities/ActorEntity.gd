extends Entity
class_name ActorEntity

func _ready() -> void:
	stats.connect("health_depleted", self, "_on_health_depleted")

func _on_health_depleted():
	pass
