extends Entity
class_name ActorEntity

signal health_changed(new_health, old_health)
signal health_depleted()
signal mana_changed(new_mana, old_mana)
signal mana_depleted()

var modifiers = {}
var health : int

var mana : int setget set_mana
export var max_health : int = 1 setget set_max_health, _get_max_health
export var max_mana : int = 0 setget set_max_mana, _get_max_mana
export var strength : int = 1 setget ,_get_strength
export var defense : int = 1 setget ,_get_defense
export var sight : int = 1 setget ,_get_sight

var level : int

func _ready() -> void:
	health = self.max_health

func reset():
	.reset()
	mana = self.max_mana

func set_max_health(value : int):
	if value == null:
		return
	max_health = max(1, value)

func heal(amount : int, from: Object) -> void:
	var old_health = health
	health = min(health + amount, max_health)
	emit_signal("health_changed", health, old_health)

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

	if !is_alive():
		add_to_group("marked_for_removal")
		_delayed_hit_animation_promise = delayed_hit_animation_promise
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

func set_mana(value : int):
	var old_mana = mana
	mana = max(0, value)
	emit_signal("mana_changed", mana, old_mana)
	if mana == 0:
		emit_signal("mana_depleted")

func set_max_mana(value : int):
	if value == null:
		return
	max_mana = max(0, value)

func add_modifier(id : int, modifier):
	modifiers[id] = modifier

func remove_modifier(id : int):
	modifiers.erase(id)

func is_alive() -> bool:
	return health > 0

func remove():
	.remove()
	_show_death()

func _get_max_health() -> int:
	return max_health

func _show_death() -> void:
	hide()

func _get_max_mana() -> int:
	return max_mana

func _get_strength() -> int:
	return strength

func _get_defense() -> int:
	return defense

func _get_level() -> int:
	return level

func _get_sight() -> int:
	return sight

