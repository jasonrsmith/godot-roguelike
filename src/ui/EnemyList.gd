extends Control

onready var _list_item_base = $NPCListItem
onready var _list = $VBoxContainer

func _ready() -> void:
	events.connect("player_fov_refreshed", self, "_on_player_fov_refreshed")

func _on_player_fov_refreshed() -> void:
	for list_item in _list.get_children():
		list_item.queue_free()
	for entity in globals.player_entity.get_visible_npcs():
		var item = _list_item_base.duplicate()
		_list.add_child(item)
		item.get_node("TextureRect").set_texture(entity.image)
		item.get_node("Label").set_text(entity.display_name)
		item.show()
	print_debug("fov refresh")
	pass
