extends Node2D
class_name DebugGrid

onready var tilemap_rect = Rect2()
onready var tilemap_cell_size = globals.board.cell_size
onready var color = Color(0.1, 0.8, 0.1, 0.1)

func _ready():
	globals.debug_grid = self
	set_process(false)
	if globals.debug_settings.show_map_grid:
		show()
	else:
		hide()
	draw_grid()

func draw_grid():
	tilemap_rect = globals.board.get_used_rect()
	update()

func _draw():
	for y in range(0, tilemap_rect.size.y):
		draw_line(Vector2(0, y * tilemap_cell_size.y), Vector2(tilemap_rect.size.x * tilemap_cell_size.x, y * tilemap_cell_size.y), color)

	for x in range(0, tilemap_rect.size.x):
		draw_line(Vector2(x * tilemap_cell_size.x, 0), Vector2(x * tilemap_cell_size.x, tilemap_rect.size.y * tilemap_cell_size.y), color)
