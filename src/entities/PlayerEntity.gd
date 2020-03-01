extends ActorEntity
class_name PlayerEntity

enum ACTION { MOVE_OR_ATTACK, WAIT, PICKUP, USE }

var _action

var _heal_fx = preload("res://src/fx/HealParticles.tscn")
var _field_of_view = FieldOfView.new(globals.board)
var _tiles_in_view : Dictionary = {}

class Action:
	var type: int
	var params: Dictionary

	func _init(type: int, params: Dictionary):
		self.type = type
		self.params = params

func _ready():
	globals.player_entity = self
	connect('health_changed', self, '_on_health_changed')
	events.connect('player_ready_for_action', self, '_on_player_ready_for_action')
	_on_health_changed(health, health)
	show()

func take_damage(hit : Hit, from: Object, delayed_hit_animation_promise = null) -> void:
	globals.camera.shake(0.25, 2)
	var from_name : String = from.display_name if "display_name" in from else "???"
	globals.console.print_line("You take " + str(hit.damage) + " damage from " + from_name + ".", globals.LOG_CAT.CRITICAL)
	.take_damage(hit, from)

func heal(amount: int, from: Object) -> void:
	var from_name : String = from.display_name if "display_name" in from else "???"
	globals.console.print_line("You heal " + str(amount) + " points from the " + from_name + ".", globals.LOG_CAT.PLAYER_INFO)
	add_child(_heal_fx.instance())
	.heal(amount, from)

func _on_health_depleted():
	globals.main.game_over()

func set_action(type: int, params = {}) -> void:
	self._action = Action.new(type, params)

func get_action() -> Action:
	return self._action

func take_turn() -> int:
	var action = get_action()
	if !action:
		return 0

	match action.type:

		ACTION.MOVE_OR_ATTACK:
			assert(action.params.has('direction'))
			var direction : Vector2 = action.params.direction
			var entity : Entity = globals.actor_area.get_at_map_pos(
				globals.board.world_to_map(position) + direction)
			if entity:
				execute_attack(direction)
			else:
				execute_move(direction)
			# TODO: give actual costs to move
			return speed

		ACTION.WAIT:
			return speed

		ACTION.USE:
			assert(action.params.has('entity'))
			var entity : Entity = action.params.entity
			assert(entity.has_method('use'))
			globals.console.print_line("You %s the %s." % [entity.use_verb_second_person, entity.display_name])

			var target
			if action.params.has('target'):
				target = action.params.target
			backpack.remove_entity(entity)
			entity.use(self, target)
			return speed

	return speed

func execute_move(direction: Vector2) -> void:
	var target_map_pos : Vector2 = globals.board.request_move(self, direction)
	if target_map_pos:
		move_to_map_pos(target_map_pos)
		var item : Entity = globals.item_area.get_at_map_pos(target_map_pos)
		if item:
			add_entity_to_backpack(item)
			globals.item_area.remove(item)
			globals.console.print_line("You pick up the " + item.display_name + ".")
		events.emit_signal("player_moved", target_map_pos)
	else:
		bump()

func execute_attack(direction: Vector2) -> void:
	var target_entity = globals.actor_area.get_at_map_pos(
		globals.board.world_to_map(position) + direction)
	var hit := Hit.new(strength)
	target_entity.take_damage(hit, self)
	globals.console.print_line("You attack " + target_entity.display_name + " for " + str(hit.damage) + " damage.")
	if !target_entity.is_alive():
		globals.console.print_line("You kill " + target_entity.display_name + ".")

func get_visible_npcs() -> Array:
	var visible_tiles : Array = get_visible_tiles()
	var entities := []
	for tile_map_pos in visible_tiles:
		var actor : Entity = globals.actor_area.get_at_map_pos(tile_map_pos)
		if actor and actor != self:
			entities.append(actor)
	return entities

func get_visible_items() -> Array:
	var visible_tiles : Array = get_visible_tiles()
	var entities := []
	for tile_map_pos in visible_tiles:
		var item : Entity = globals.item_area.get_at_map_pos(tile_map_pos)
		if item:
			entities.append(item)
	return entities

func get_visible_entities() -> Array:
	# TODO: refactor into FieldOfView so that all entities can use
	# TODO: refactor *_area into EntityContainers script, inject into fov
	return get_visible_npcs() + get_visible_items()

func get_visible_tiles() -> Array:
	return _field_of_view.get_tiles_in_view().keys()

func is_tile_visible(map_pos: Vector2) -> bool:
	# TODO: is this needed after refactoring?
	return _field_of_view.in_fov(map_pos)

func acquire_target(max_range: int) -> Promise:
	var visible_entities : Array = get_visible_npcs()
	var targetable_entities : Array = []
	for e in visible_entities:
		var distance = get_map_pos().distance_to(e.get_map_pos())
		if distance <= max_range:
			targetable_entities.append(e)

	var promise : Promise = Promise.new()

	if targetable_entities.size() == 0:
		promise.call_deferred("complete")
		return promise
	promise = globals.character_info_modal.show_select_entity("Choose Target", visible_entities)
	return promise

func refresh_fov() -> void:
	var refreshed_tiles_in_view: Dictionary = _field_of_view.refresh(get_map_pos(), sight)

	# look for tiles that went out of view
	for map_pos in _tiles_in_view.keys():
		if !refreshed_tiles_in_view.has(map_pos):
			events.emit_signal("tile_went_out_of_view", map_pos)

	# look for newly seen tiles
	for map_pos in refreshed_tiles_in_view.keys():
		if !_tiles_in_view.has(map_pos):
			events.emit_signal("tile_was_seen", map_pos)

	_tiles_in_view = refreshed_tiles_in_view
	events.emit_signal("player_fov_refreshed")

func _on_health_changed(health: int, old_health: int):
	events.emit_signal("player_health_changed", health, old_health)

func _on_player_ready_for_action():
	refresh_fov()
