extends Control
class_name EnemyList

onready var _list = $VBoxContainer

const EntityListItemScene = preload("res://src/ui/EntityListItem.tscn")

func _ready() -> void:
	events.connect('player_ready_for_action', self, '_on_player_ready_for_action')
	events.connect('entity_removed', self, '_on_entity_removed')

func refresh() -> void:
	for list_item in _list.get_children():
		list_item.queue_free()
	for entity in globals.player_entity.get_visible_entities():
		var item : EntityListItem = EntityListItemScene.instance()
		_list.add_child(item)
		item.init_with_entity(entity)

func _on_player_ready_for_action() -> void:
	refresh()

func _on_entity_removed(entity: Entity) -> void:
	refresh()
