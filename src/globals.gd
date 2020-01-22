extends Node2D
class_name globals
enum CELL_TYPES { EMPTY = -1, FLOOR, WALL }
enum MASK_CELL_TYPES { INVISIBLE, DARK, EMPTY }

var map_cell_size : int = 16
var player_entity : PlayerEntity

var rng = RandomNumberGenerator.new()

const LASER_COLOR = Color(0.9, 0.2, 0.1)

func _init():
	rng.randomize()