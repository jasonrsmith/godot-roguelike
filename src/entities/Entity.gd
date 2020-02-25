extends KinematicBody2D
class_name Entity

onready var pivot : Node2D = $Pivot
onready var sprite : Sprite = $Pivot/Sprite
onready var tween : Tween = $Tween
onready var tooltip  = $TooltipCanvas/Tooltip
onready var backpack = $Backpack
onready var hit_animation = preload("res://src/fx/HitEffect.tscn")

export var speed : int = 0 setget ,_get_speed
export var display_name : String = "thing"
export var description : String
export var max_health : int = 1 setget set_max_health, _get_max_health
export var image : Texture
export var is_proper_noun : bool = false
export var is_burnable : bool = true

var action_points : int
var health : int

var is_alive : bool setget ,_is_alive
var _inside_backpack : Backpack

func _ready() -> void:
	set_process(false)
	tooltip.set_entity(self)
	health = self.max_health
	sprite.set_texture(image)
	globals.time_manager.register(self)

func move_to_map_pos(target_map_pos: Vector2) -> void:
	set_process(false)
	var world_pos : Vector2 = globals.board.map_to_world(target_map_pos) \
		+ (globals.map_cell_size * Vector2.ONE / 2)
	var move_direction : Vector2 = (world_pos - position).normalized()
	position = world_pos
	pivot.position = -1 * move_direction * 8.0
	tween.interpolate_property(
		pivot,
		"position",
		pivot.position,
		Vector2(),
		0.08,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT_IN)
	tween.start()
	set_process(true)
	if move_direction.x < 0:
		sprite.set_flip_h(true)
	elif move_direction.x > 0:
		sprite.set_flip_h(false)

func bump() -> void:
	#print_debug("bump")
	set_process(false)
	# TODO: tween / anim
	set_process(true)

# TODO: yield doesn't work when dead
func remove():
	hide()
	globals.time_manager.release(self)
	queue_free()

func set_map_pos(map_pos: Vector2):
	position = (globals.board.map_to_world(map_pos) +
		globals.board.cell_size / 2)

func get_map_pos():
	return globals.board.world_to_map(position)

func add_entity_to_backpack(entity: Entity) -> void:
	backpack.add_entity(entity)
	entity.hide()
	entity._inside_backpack = backpack

func remove_entity_from_backpack(entity: Entity) -> void:
	backpack.remove_entity(entity)
	entity._inside_backpack = null

func take_damage(hit : Hit, from: Object, delayed_hit_animation_promise = null) -> void:
	if !delayed_hit_animation_promise:
		var animation : HitEffect = hit_animation.instance()
		add_child(animation)
		animation.run_once()

	var old_health = health
	health -= hit.damage
	health = max(0, health)
	emit_signal("health_changed", health, old_health)
	if health == 0:
		emit_signal("health_depleted")

	if !_is_alive():
		# TODO refactor to NPCEntity
		globals.actor_area.remove(self)
		if delayed_hit_animation_promise:
			yield(delayed_hit_animation_promise, "done")
		hide()
		return

	for i in range(4):
		self.modulate.a = 0.5
		self.modulate.r = 2.0
		self.modulate.g = 0.1
		self.modulate.b = 0.1
		yield(get_tree(), "idle_frame")
		self.modulate.a = 1.0
		self.modulate.r = 1.0
		self.modulate.g = 1.0
		self.modulate.b = 1.0
		yield(get_tree(), "idle_frame")

func set_max_health(value : int):
	if value == null:
		return
	max_health = max(1, value)

func heal(amount : int, from: Object) -> void:
	var old_health = health
	health = min(health + amount, max_health)
	emit_signal("health_changed", health, old_health)

func drop() -> void:
	pass

func _get_speed() -> int:
	return speed

func _get_max_health() -> int:
	return max_health

func _is_alive() -> bool:
	return health > 0

func _on_collide_with_entity(entity: Entity):
	print_debug(str(self) + " collides with " + str(entity))
