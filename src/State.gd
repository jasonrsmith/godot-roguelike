extends Node2D

var _entities = []
var _next_entity_idx = 0

export(bool) var debug_actions = true

func _ready() -> void:
	run_actions()

func register(entity) -> void:
	_entities.append(entity)

func release(entity) -> void:
	_entities.erase(entity)

func run_actions():
	if _entities.size() == 0:
		assert("nothing to run!")
		return
	while true:
		var entity = _entities[_next_entity_idx]
		if !entity.stats.is_alive:
			release(entity)
			continue
		_next_entity_idx = (
			(_next_entity_idx + 1) %
			_entities.size())
		entity.stats.action_points += entity.stats.speed
		while entity.stats.action_points > 0:
			if entity == globals.player_entity:
				globals.fov.refresh(
					globals.board.world_to_map(globals.player_entity.position))
				yield(events, "player_acted")
			entity.stats.action_points -= entity.take_turn()
