extends Node2D
class_name Scene

onready var _board : Board = $Board
onready var _player_input : PlayerInput = $Board/PlayerEntity/PlayerInput
onready var _player_entity : Entity = $Board/PlayerEntity
onready var _path_finder : PathFinder = $PathFinder
onready var _fov: FOV = $FOV
onready var _debug_canvas = $DebugCanvas
onready var _camera = $Board/PlayerEntity/Pivot/Sprite/Camera2D
onready var _dead_panel = $Dead/DeadPanel
onready var _stats_ui = $StatsUI

func _ready() -> void:
	OS.set_window_size(Vector2(1024, 768))
	set_globals()
	
	_player_input.initialize(_player_entity, _board)
	_fov.initialize(_player_entity, _board)
	_board.init_map()
	var player_map_pos = _board.find_player_spawn_point()
	_board.add_entity(_player_entity, player_map_pos)
	_fov.refresh(player_map_pos)
	_board.populate_enemies()


func set_globals():
	globals.dead_panel = _dead_panel
