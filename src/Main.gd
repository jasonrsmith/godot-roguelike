extends Node2D
class_name Main

func _ready() -> void:
	globals.main = self
	_init_rng()

	OS.set_window_size(Vector2(1024, 768))
	globals.player_input.initialize(globals.player_entity)
	globals.board.init_map()
	
	var player_map_pos = globals.board.find_player_spawn_point()
	globals.player_entity.set_map_pos(player_map_pos)
	
	globals.board.populate_rooms()
	globals.fov.refresh(player_map_pos)
	
	if globals.debug_settings.give_player_start_items:
		_debug_give_player_stuff()
	
	globals.time_manager.run_actions()

func _debug_give_player_stuff():
	var item = globals.spawner.random_item()
	add_child(item)
	globals.player_entity.add_entity_to_backpack(item)

func _init_rng():
	if globals.debug_settings.rng_seed.empty():
		globals.rng.randomize()
		globals.rng.set_seed(abs(globals.rng.get_seed() % 2147483647))
	else:
		globals.rng.set_seed(("0x" + globals.debug_settings.rng_seed).hex_to_int())
	print_debug("seed: %x" % globals.rng.get_seed())

func game_over():
	globals.dead_screen.show()
