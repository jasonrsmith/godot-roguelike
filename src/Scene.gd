extends Node2D
class_name Scene

onready var _board : Board = $Board
onready var _player_input : PlayerInput = $PlayerInput
onready var _player_entity : Entity = $PlayerEntity


func _ready() -> void:
	_player_input.initialize(_player_entity, _board)
	place_in_scene(_player_entity, Vector2(1, 1))

func place_in_scene(entity : Entity, pos : Vector2):
	entity.move_to(_board.add_entity(entity, pos))
