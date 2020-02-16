extends Node2D
class_name Main

onready var _board : Board = $Board
onready var _player_input : PlayerInput = $PlayerEntity/PlayerInput
onready var _player_entity : Entity = $PlayerEntity
onready var _path_finder : PathFinder = $PathFinder
onready var _fov: FOV = $FOV
onready var _camera : Camera2D = $PlayerEntity/Pivot/Sprite/Camera2D
onready var _dead_panel : Panel = $DeadScreen/DeadPanel
onready var _stats_ui = $StatsUI

func _ready() -> void:
	OS.set_window_size(Vector2(1024, 768))
	set_globals()
	
	_player_input.initialize(_player_entity)
	_fov.initialize(_player_entity, _board)
	_board.init_map()
	var player_map_pos = _board.find_player_spawn_point()
	_player_entity.set_map_pos(player_map_pos)
	_board.add_entity(_player_entity)
	_board.populate_rooms()
	_fov.refresh(player_map_pos)
	globals.time_manager.run_actions()
	
	_debug_give_player_stuff()

func set_globals():
	globals.dead_panel = _dead_panel

func _debug_give_player_stuff():
	var item = globals.spawner.random_item()
	add_child(item)
	_player_entity.add_entity_to_backpack(item)
	
