extends Node2D
class_name globals
enum CELL_TYPES { EMPTY = -1, FLOOR, WALL }
enum MASK_CELL_TYPES { INVISIBLE, DARK, EMPTY }

var map_cell_size : int = 16

var rng = RandomNumberGenerator.new()

func _init():
	rng.randomize()