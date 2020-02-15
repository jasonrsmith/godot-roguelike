extends Node2D
class_name Backpack

var _entities : Array = []

func add_entity(entity) -> void:
	_entities.append(entity)

func get_all_entities() -> Array:
	return _entities

func remove_entity(entity) -> void:
	_entities.erase(entity)
