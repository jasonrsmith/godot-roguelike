extends Control

onready var _list = $VBoxContainer

const EntityListItemScene = preload("res://src/ui/EntityListItem.tscn")

func _ready() -> void:
	# TODO: emit from player entity
	events.connect("player_fov_refreshed", self, "_on_player_fov_refreshed")

func _on_player_fov_refreshed() -> void:
	for list_item in _list.get_children():
		list_item.queue_free()
	for entity in globals.player_entity.get_visible_entities():
		var item : EntityListItem = EntityListItemScene.instance()
		_list.add_child(item)
		item.init(entity.display_name, entity.image)
