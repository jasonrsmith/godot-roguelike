extends Node2D
class_name globals
enum CELL_TYPES { EMPTY = -1, FLOOR, WALL }
enum MASK_CELL_TYPES { INVISIBLE, DARK, EMPTY }

var map_cell_size : int = 16
var player_entity
var path_finder
var debug_canvas
var board
var camera

var rng = RandomNumberGenerator.new()

onready var system_label = preload("res://src/SystemLabel.tscn")

const LASER_COLOR = Color(0.9, 0.2, 0.1)

func _init():
	rng.randomize()