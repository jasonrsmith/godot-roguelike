extends Node2D
class_name DebugSettings

export var show_enemy_sight : bool
export var show_map_grid : bool setget set_show_map_grid
export var give_player_start_items : bool
export var show_mouse_pos : bool setget set_show_mouse_pos

func _ready() -> void:
	globals.debug_settings = self

func set_show_mouse_pos(enabled: bool) -> void:
	if !globals.debug_mouse_pos:
		return
	if enabled:
		globals.debug_mouse_pos.show()
	else:
		globals.debug_mouse_pos.hide()

func set_show_map_grid(enabled: bool) -> void:
	if !globals.debug_grid:
		return
	if enabled:
		globals.debug_grid.show()
	else:
		globals.debug_grid.hide()
