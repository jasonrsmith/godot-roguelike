extends Node2D
class_name Scene

onready var _board : Board = $Board
onready var _player_input : PlayerInput = $PlayerInput
onready var _player_entity : Entity = $PlayerEntity
onready var _fov: FOV = $FOV


func _ready() -> void:
	OS.set_window_size(Vector2(1024, 768))
	_player_input.initialize(_player_entity, _board)
	_fov.initialize(_player_entity, _board)
	var player_map_pos = Vector2(4, 6)
	place_in_scene(_player_entity, player_map_pos)
	_fov.refresh(player_map_pos)
	events.emit_signal("tile_was_seen", player_map_pos)


func place_in_scene(entity : Entity, pos : Vector2):
	entity.move_to(_board.add_entity(entity, pos))