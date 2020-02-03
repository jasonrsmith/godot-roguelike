extends TileMap
class_name TileVisibilityPainter

var _draw_polygons = []


func _ready() -> void:
	events.connect("tile_was_seen", self, "_on_tile_was_seen")
	events.connect("tile_went_out_of_view", self, "_on_tile_went_out_of_view")

func mask_full(map_pos: Vector2):
	var x := map_pos.x
	var y := map_pos.y
	var size : Vector2 = globals.board.board_size
	if x == 0 or x == size.x-1 or y == 0 or y == size.y-1:
		set_cellv(map_pos, globals.MASK_CELL_TYPES.DARK)
		for xi in range (-1, 1):
			for yi in range(-1, 1):
				set_cellv(map_pos + Vector2(xi, yi), globals.MASK_CELL_TYPES.DARK)
	else:
		set_cellv(map_pos, globals.MASK_CELL_TYPES.DARK)

func mask_dark(map_pos: Vector2):
	set_cellv(map_pos, globals.MASK_CELL_TYPES.DARK)
	update_bitmask_area(map_pos)

func mask_off(map_pos: Vector2):
	set_cellv(map_pos, globals.MASK_CELL_TYPES.EMPTY)
	update_bitmask_area(map_pos)

func _on_tile_was_seen(tile_map_pos: Vector2) -> void:
	#mask_off(tile_map_pos)
	mask_off(tile_map_pos)

func _on_tile_went_out_of_view(tile_map_pos: Vector2) -> void:
	pass
	#mask_off(tile_map_pos)
	#mask_off(tile_map_pos)
