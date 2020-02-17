extends Entity
class_name ActorEntity

signal health_changed(new_health, old_health)
signal health_depleted()
signal mana_changed(new_mana, old_mana)
signal mana_depleted()

var modifiers = {}

var mana : int setget set_mana
export var max_mana : int = 0 setget set_max_mana, _get_max_mana
export var strength : int = 1 setget ,_get_strength
export var defense : int = 1 setget ,_get_defense
export var speed : int = 1 setget ,_get_speed
export var sight : int = 1 setget ,_get_sight

var action_points : int
var level : int

func _ready() -> void:
	pass

	
func reset():
	.reset()
	mana = self.max_mana
	
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
	
func _get_max_mana() -> int:
	return max_mana

func _get_strength() -> int:
	return strength
	
func _get_defense() -> int:
	return defense
	
func _get_speed() -> int:
	return speed

func _get_level() -> int:
	return level

func _get_sight() -> int:
	return sight

