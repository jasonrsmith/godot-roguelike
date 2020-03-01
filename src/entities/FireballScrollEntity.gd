extends ScrollEntity
class_name FireballScrollEntity

const FireballFx = preload("res://src/fx/Fireball.tscn")

export var damage : int
export var max_range : int
export var aoe_radius : int

const FireEntityScene = preload("res://src/entities/FireEntity.tscn")

var _field_of_view = FieldOfView.new(globals.board)

func use(entity: Entity, target_entity = null) -> void:
	if !target_entity:
		globals.console.print_line("There's nothing you can target.  You lose the scroll and feel very foolish.  You contemplate giving up the adventuring lifestyle for good, learning computer programming, and getting a high-paying job in tech.")
		return

	var fireball_fx = FireballFx.instance()
	get_tree().get_root().add_child(fireball_fx)
	fireball_fx.init(target_entity)
	fireball_fx.position = entity.position

	var animation_finished_promise : Promise = Promise.new()
	var target_name : String = (target_entity.display_name
		if target_entity.is_proper_noun
		else "the " + target_entity.display_name)

	var hit := Hit.new(damage)
	target_entity.take_damage(hit, self, animation_finished_promise)
	yield(fireball_fx, "tree_exited")
	create_fire(target_entity.get_map_pos())
	animation_finished_promise.complete()

	globals.console.print_line("The fireball hits %s for %d damage." % [target_name, hit.damage])
	if !target_entity.is_alive():
		globals.console.print_line("The fireball kills %s." % target_name)
	remove()

func use_on(entity: Entity, target_entity: Entity) -> void:
	use(entity, target_entity)

func create_fire(target_map_pos: Vector2) -> void:
	var tiles : Dictionary = _field_of_view.refresh(target_map_pos, aoe_radius)
	tiles[target_map_pos] = true
	for map_pos in tiles.keys():
		if globals.board.is_wall(map_pos):
			continue
		var fire = FireEntityScene.instance()
		fire.set_map_pos(map_pos)
		globals.environmental_effect_area.add_or_replace(fire)




