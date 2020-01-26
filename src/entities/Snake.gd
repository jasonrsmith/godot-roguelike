extends NPCEntity
class_name Snake

func _ready():
	pass

func _on_player_seen(map_pos: Vector2):
	._on_player_seen(map_pos)
	State.queue_action(self, 100, "bristles", {})


func _on_player_lost(map_pos: Vector2):
	._on_player_lost(map_pos)
	State.queue_action(self, 100, "gets confused", {})

func run_action(name: String, params: Dictionary):
	print_debug(self.name, " ", name)