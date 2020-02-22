extends ScrollEntity
class_name MagicMissleScrollEntity

const MissleFx = preload("res://src/fx/Missle.tscn")

export var damage : int
export var missle_range : int

func use(entity: Entity, target_entity = null) -> void:
	if !target_entity:
		globals.console.print_line("There's nothing you can target.  You lose the scroll and feel very foolish.  You contemplate giving up the adventuring lifestyle for good, learning computer programming, and getting a high-paying job in tech.")
		return
	
	var missle_fx = MissleFx.instance()
	get_tree().get_root().add_child(missle_fx)
	missle_fx.init(target_entity)
	missle_fx.position = entity.position
	
	var animation_finished_promise : Promise = Promise.new()
	var target_name : String = (target_entity.display_name
		if target_entity.is_proper_noun
		else "the " + target_entity.display_name)
	
	var hit := Hit.new(damage)
	target_entity.take_damage(hit, self, animation_finished_promise)
	yield(missle_fx, "tree_exited")
	animation_finished_promise.complete()
	
	globals.console.print_line("The missle hits %s for %d damage." % [target_name, hit.damage])
	if !target_entity.is_alive:
		globals.console.print_line("The missle kills %s." % target_name)
		target_entity.hide()

func acquire_target(entity: Entity) -> Promise:
	var visible_entities : Array = globals.player_entity.get_visible_npcs()
	var targetable_entities : Array = []
	for e in visible_entities:
		var distance = entity.get_map_pos().distance_to(e.get_map_pos())
		if distance <= missle_range:
			targetable_entities.append(e)
	
	var promise : Promise = Promise.new()
	
	if targetable_entities.size() == 0:
		promise.call_deferred("complete")
		return promise
	promise = globals.character_info_modal.show_select_entity("Choose Target", visible_entities)
	return promise
