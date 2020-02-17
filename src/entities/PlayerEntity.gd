extends ActorEntity
class_name PlayerEntity

enum ACTION { MOVE_OR_ATTACK, WAIT, PICKUP }

var _action

class Action:
	var type: int
	var params: Dictionary

	func _init(type: int, params: Dictionary):
		self.type = type
		self.params = params

func _ready():
	globals.player_entity = self
	globals.time_manager.register(self)
	stats.connect('health_changed', self, '_on_health_changed')
	_on_health_changed(stats.health, stats.health)


func take_damage(hit: Hit, _from: Object) -> void:
	print_debug(_from.get_instance_id())
	globals.camera.shake(0.25, 3)
	var from_name : String = _from.display_name if "display_name" in _from else "???"
	globals.console.print_line("You take " + str(hit.damage) + " damage from " + from_name + ".", globals.LOG_CAT.CRITICAL)
	.take_damage(hit, _from)

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
			var direction = action.params.direction
			var entity = globals.npc_area.get_npc_at(
				globals.board.world_to_map(position) + direction)
			if entity:
				execute_attack(direction)
			else:
				execute_move(direction)
			# TODO: give actual costs to move
			return stats.speed
		
		ACTION.WAIT:
			return stats.speed
		
		ACTION.PICKUP:
			var items : Array = globals.item_area.get_items_at_map_pos(get_map_pos())
			if items.size() == 0:
				globals.console.print_line("You don't see anything to pickup!  You feel silly.")
				return 0
			elif items.size() == 1:
				var item : Entity = items[0]
				add_entity_to_backpack(item)
				globals.item_area.remove_item(item)
				globals.console.print_line("You pick up the " + item.display_name + ".")
				return stats.speed
			else:
				globals.ui.show_pickup_screen()
				return 0
	
	return stats.speed

func execute_move(direction: Vector2) -> void:
	var target_map_pos : Vector2 = globals.board.request_move(self, direction)
	if target_map_pos:
		move_to_map_pos(target_map_pos)
		events.emit_signal("player_moved", target_map_pos)
	else:
		bump()

func execute_attack(direction: Vector2) -> void:
	var target_entity = globals.npc_area.get_npc_at(
		globals.board.world_to_map(position) + direction)
	var hit := Hit.new(stats.strength)
	target_entity.take_damage(hit, self)
	globals.console.print_line("You attack " + target_entity.display_name + " for " + str(hit.damage) + " damage.")
	if !target_entity.stats.is_alive:
		globals.console.print_line("You kill " + target_entity.display_name + ".")

func _on_health_changed(health: int, old_health: int):
	events.emit_signal("player_health_changed", health, old_health)
