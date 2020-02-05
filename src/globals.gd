extends Node2D

enum CELL_TYPES { EMPTY = -1, FLOOR, WALL, BLACK }
enum MASK_CELL_TYPES { EMPTY = -1, FULL, DARK }
enum LOG_CAT {DEBUG, PLAYER_INFO, ERROR}

var map_cell_size : int = 16
var player_entity
var player_input
var path_finder
var debug_canvas
var board
var camera
var dead_panel
var npc_area
var fov

var max_int = 9223372036854775807

var rng = RandomNumberGenerator.new()

onready var system_label = preload("res://src/SystemLabel.tscn")

const LASER_COLOR = Color(0.9, 0.2, 0.1)

func _init():
	rng.randomize()

func game_over():
	dead_panel.show()
