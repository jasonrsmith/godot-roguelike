extends EntityMapIndex
class_name ItemArea

var _item_idx = {}

func _ready() -> void:
	globals.item_area = self

func _on_tile_went_out_of_view(map_pos: Vector2) -> void:
	# override base class so we're not hiding items
	pass
