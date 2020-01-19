extends Node2D
class_name Tile

var pos: Vector2
var is_wall = false
var _is_visible = false
var _was_seen = false


func _ready() -> void:
	pass

func _init(map_pos : Vector2) -> void:
	pos = map_pos

func set_is_wall(is_wall: bool) -> void:
	self.is_wall = is_wall

func set_is_visible(is_visible: bool) -> void:
	if _is_visible != is_visible:
		_is_visible = is_visible
		if _is_visible:
			_was_seen = true
			events.emit_signal("tile_was_seen", pos)
		else:
			events.emit_signal("tile_went_out_of_view", pos)