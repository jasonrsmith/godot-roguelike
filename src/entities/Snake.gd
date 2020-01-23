extends NPCEntity
class_name Snake

func _ready():
	pass

func _on_player_seen(player_entity: PlayerEntity):
	State.queue_action(self, 100, "bristles", {})


func _on_player_lost(player_entity: PlayerEntity):
	State.queue_action(self, 100, "gets confused", {})

func run_action(name: String, params: Dictionary):
	print_debug(self.name, " ", name)