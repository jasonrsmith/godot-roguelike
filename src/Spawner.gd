extends Node2D
class_name Spawner

onready var _peter_entity = preload("res://src/entities/Peter.tscn")
onready var _snake_entity = preload("res://src/entities/Snake.tscn")
onready var _goblin_entity = preload("res://src/entities/Goblin.tscn")

onready var _health_potion_entity = preload("res://src/entities/HealthPotionEntity.tscn")
onready var _magic_missle_scroll = preload("res://src/entities/MagicMissleScrollEntity.tscn")
onready var _fireball_scroll = preload("res://src/entities/FireballScrollEntity.tscn")

onready var _player_entity = preload("res://src/entities/PlayerEntity.tscn")

export var max_monsters_per_room : int = 5
export var max_items_per_room : int = 2

func _ready():
	globals.spawner = self
	set_process(false)

func random_monster() -> NPCEntity:
	var monster_scenes = [
		_peter_entity,
		_snake_entity,
		_goblin_entity,
	]
	var monster : NPCEntity
	var scene_idx = globals.rng.randi_range(0, monster_scenes.size() - 1)
	return monster_scenes[scene_idx].instance()

func random_item() -> Entity:
	var item_scenes = [
		_health_potion_entity,
		_magic_missle_scroll,
		_fireball_scroll,
	]
	var item : Entity
	var scene_idx = globals.rng.randi_range(0, item_scenes.size() - 1)
	return item_scenes[scene_idx].instance()

func fireball_scroll() -> FireballScrollEntity:
	return _fireball_scroll.instance()

func magic_missle_scroll() -> MagicMissleScrollEntity:
	return _magic_missle_scroll.instance()

func health_potion() -> HealthPotionEntity:
	return _health_potion_entity.instance()

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

func spawn_player() -> void:
	globals.player_entity = _player_entity.instance()
	var player_map_pos = globals.board.find_player_spawn_point()
	globals.player_entity.set_map_pos(player_map_pos)
