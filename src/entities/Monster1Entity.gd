extends Entity
class_name Monster1Entity

func _ready():
	events.connect("player_moved", self, "_on_player_moved")

func _on_player_moved(world_pos: Vector2) -> void:
	print_debug("monster1 detected player moved ", world_pos)