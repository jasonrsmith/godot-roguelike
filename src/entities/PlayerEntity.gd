extends Entity
class_name PlayerEntity

enum ACTION { MOVE_OR_ATTACK }

var _action

class Action:
	var type: int
	var params: Dictionary

	func _init(type: int, params: Dictionary):
		self.type = type
		self.params = params

func _ready():
	globals.player_entity = self
	State.register(self)
	print_debug("player ready")

func take_damage(hit: Hit, _from: Object) -> void:
	globals.camera.shake(0.25, 3)
	var from_name : String = _from.display_name if "display_name" in _from else "???"
	globals.debug_canvas.print_line("Player takes " + str(hit.damage) + " damage from " + from_name + ".")
	.take_damage(hit, _from)

func _on_health_depleted():
	globals.game_over()

func set_action(type: int, params: Dictionary) -> void:
	self._action = Action.new(type, params)

func get_action() -> Action:
	return self._action

func take_turn() -> int:
	var action = get_action()
	if action:
		if action.type == ACTION.MOVE_OR_ATTACK:
			assert(action.params.has('direction'))
			var direction = action.params.direction
			var entity = globals.board.get_entity_at(
				globals.board.world_to_map(position) + direction)
			if entity:
				execute_attack(direction)
			else:
				execute_move(direction)
		# TODO: give actual costs to move
		return 100
	return 0

func execute_move(direction: Vector2) -> void:
	var target_map_pos : Vector2 = globals.board.request_move(self, direction)
	if target_map_pos:
		move_to_map_pos(target_map_pos)
		events.emit_signal("player_moved", target_map_pos)
	else:
		bump()

func execute_attack(direction: Vector2) -> void:
	var target_entity = globals.board.get_entity_at(
		globals.board.world_to_map(position) + direction)
	var hit := Hit.new(stats.strength)
	target_entity.take_damage(hit, self)
	globals.debug_canvas.print_line("You attack " + target_entity.display_name + " for " + str(hit.damage) + " damage.")
	if !target_entity.stats.is_alive:
		globals.debug_canvas.print_line("You kill " + target_entity.display_name + ".")
