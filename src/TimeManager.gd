extends Node2D
class_name TimeManager

var _entities = []
var _next_entity_idx = 0

export(bool) var debug_actions = true

func _ready() -> void:
	globals.time_manager = self
	set_process(false)

func register(entity) -> void:
	_entities.append(entity)

func release(entity) -> void:
	_entities.erase(entity)

func run_actions():
	if _entities.size() == 0:
		assert(false, "nothing to run!")
		return
	while true:
		if _next_entity_idx == _entities.size():
			_next_entity_idx = 0
		var entity = _entities[_next_entity_idx]
		if !entity or entity.is_queued_for_deletion() or !entity.is_alive:
			release(entity)
			continue
		_next_entity_idx = (
			(_next_entity_idx + 1) %
			_entities.size())
		entity.action_points += entity.speed
		while entity.action_points > 0:
			if entity == globals.player_entity:
				globals.player_entity.refresh_fov()
				yield(events, "player_acted")
			entity.action_points -= entity.take_turn()
