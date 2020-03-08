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
export var image : Texture
export var is_proper_noun : bool = false
export var is_burnable : bool = true
export var move_animation_duration = 0.1

var action_points : int

var _is_alive : bool
var _inside_backpack : Backpack
var _delayed_hit_animation_promise : Promise
var _status_effects = []

func _ready() -> void:
	tooltip.set_entity(self)
	sprite.set_texture(image)
	globals.time_manager.register(self)

func move_to_map_pos(target_map_pos: Vector2) -> void:
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
		move_animation_duration,
		Tween.TRANS_LINEAR)
	tween.start()
	if move_direction.x < 0:
		sprite.set_flip_h(true)
	elif move_direction.x > 0:
		sprite.set_flip_h(false)

func bump() -> void:
	# TODO: tween / anim
	pass

func remove():
	remove_from_group("marked_for_removal")
	add_to_group("removed")
	events.emit_signal("entity_removed", self)

	# TODO HACK: workaround for death animation getting interupted
	var expire_timer = get_tree().create_timer(0.5)
	expire_timer.connect("timeout", self, "_on_expire_timer_timeout")

	if _delayed_hit_animation_promise:
		yield(_delayed_hit_animation_promise, "done")

func cleanup():
	hide()
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

func add_status_effect(effect: StatusEffect) -> void:
	for effect_already_in_list in _status_effects:
		# don't add effects already listed
		if typeof(effect_already_in_list) == typeof(effect):
			return
	_status_effects.append(effect)
	add_child(effect)
	effect.init(self)

func process_status_effects(action_points: int) -> void:
	var i := 0
	while i < _status_effects.size():
		var effect : StatusEffect = _status_effects[i]
		if !effect.run_for_action_points(action_points):
			_status_effects.remove(i)
			globals.console.print_line("%s stops %s." % [display_name, effect.display_name])
		else:
			i += 1

func drop() -> void:
	pass

func hide() -> void:
	.hide()

func _on_collide_with_entity(entity: Entity) -> void:
	print_debug(str(self) + " collides with " + str(entity))

func _on_expire_timer_timeout() -> void:
	cleanup()

func _get_speed() -> int:
	return speed
