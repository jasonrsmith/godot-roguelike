extends Entity
class_name PlayerEntity

func _ready():
	globals.player_entity = self
	print_debug("player ready")

func take_damage(hit: Hit, _from: Object) -> void:
	var from_name : String = _from.display_name if "display_name" in _from else "???"
	globals.debug_canvas.print_line("Player takes " + str(hit.damage) + " damage from " + from_name + ".")
	.take_damage(hit, _from)

func _on_health_depleted():
	globals.game_over()

