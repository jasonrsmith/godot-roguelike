extends ScrollEntity
class_name MagicMissleScrollEntity

const MissleFx = preload("res://src/fx/Missle.tscn")

export var damage : int
export var missle_range : int

func use(entity: Entity) -> void:
	if !entity == globals.player_entity:
		return
	var visible_entities : Array = globals.player_entity.get_visible_npcs()
	if visible_entities.size() == 0:
		globals.console.print_line("There's nothing you can target.  You lose the scroll and feel foolish.")
		return
	var promise : Promise = globals.character_info_modal.show_select_entity("Choose Target", visible_entities)
	yield(promise, "done")
	var target_entity = promise.response.result
	if not target_entity is Entity:
		return
	var missle_fx = MissleFx.instance()
	get_tree().get_root().add_child(missle_fx)
	missle_fx.init(target_entity)
	missle_fx.position = entity.position
