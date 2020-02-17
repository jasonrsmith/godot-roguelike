extends Node2D
class_name Spawner

onready var _chad_entity = preload("res://src/entities/Chad.tscn")
onready var _snake_entity = preload("res://src/entities/Snake.tscn")
onready var _entity = preload("res://src/entities/Entity.tscn")

export var max_monsters_per_room : int = 5
export var max_items_per_room : int = 2

func _ready():
	globals.spawner = self
	set_process(false)

func random_monster() -> NPCEntity:
	var monster : NPCEntity
	if globals.rng.randf() > 0.5:
		monster = _chad_entity.instance()
	else:
		monster = _snake_entity.instance()
	return monster

func random_item() -> Entity:
	var item : Entity
	item = _entity.instance()
	item.load_stats("res://src/items/health_potion_small_item.tres")
	return item

func spawn_room(room: Rect2, spawn_type: String, minn: int, maxn: int) -> Array:
	var entity_spawn_points := {}
	var num_entities : int = int(rand_range(minn, maxn))
	var spawned_entities = []
	
	for i in range(num_entities):
		var added := false
		while !added:
			var x : float = (room.position.x +
				floor(globals.rng.randf_range(0, room.size.x)))
			var y : float = (room.position.y +
				floor(globals.rng.randf_range(0, room.size.y)))
			var map_pos := Vector2(x, y)
			if !entity_spawn_points.has(map_pos):
				entity_spawn_points[map_pos] = true
				added = true
	for spawn_point in entity_spawn_points:
		var entity : Entity = call(spawn_type)
		entity.set_map_pos(spawn_point)
		spawned_entities.append(entity)
	return spawned_entities
