extends Entity
class_name PlayerEntity

func _ready():
	globals.player_entity = self
	print_debug("player ready")

func _on_health_depleted():
	globals.game_over()