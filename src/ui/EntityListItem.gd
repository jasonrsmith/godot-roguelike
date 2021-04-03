extends ListItem
class_name EntityListItem

onready var _entity_stats : MarginContainer = $VBox/EntityStats

func init_with_entity(entity: Entity, shortcut = "") -> void:
	.init(entity.display_name, entity.image, shortcut)
	if "health" in entity:
		_entity_stats.init(entity)
		_entity_stats.show()

func _calculate_child_height() -> float:
	var child_height = 0
	if _entity_stats.is_visible_in_tree():
		child_height += _entity_stats.rect_size.y + 8
	return child_height + ._calculate_child_height()
