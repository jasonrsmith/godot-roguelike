extends Entity
class_name PlayerEntity

func _on_health_depleted():
	globals.game_over()