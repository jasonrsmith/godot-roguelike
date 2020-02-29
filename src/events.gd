extends Node

signal game_ready

signal entity_removed(entity)

signal player_moved(map_pos)
signal player_acted
signal player_health_changed
signal player_fov_refreshed

signal tile_was_seen(map_pos)
signal tile_went_out_of_view(map_pos)
signal tile_was_obscured(map_pos)

signal inventory_action_modal_closed
