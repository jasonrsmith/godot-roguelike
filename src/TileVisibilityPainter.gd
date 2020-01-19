extends TileMap
class_name TileVisibilityPainter

var _draw_polygons = []


func _ready() -> void:
	events.connect("tile_was_seen", self, "_on_tile_was_seen")
	events.connect("tile_went_out_of_view", self, "_on_tile_went_out_of_view")


func mask_full(map_pos: Vector2):
	set_cellv(map_pos, globals.MASK_CELL_TYPES.INVISIBLE)

func mask_dark(map_pos: Vector2):
	set_cellv(map_pos, globals.MASK_CELL_TYPES.DARK)

func mask_off(map_pos: Vector2):
	set_cellv(map_pos, globals.MASK_CELL_TYPES.EMPTY)

func _on_tile_was_seen(tile_map_pos: Vector2) -> void:
	mask_off(tile_map_pos)

func _on_tile_went_out_of_view(tile_map_pos: Vector2) -> void:
	mask_dark(tile_map_pos)