extends Entity
class_name FireEntity

export var burn_turns_min : int
export var burn_turns_max : int
export var damage : int

onready var _burning = $Burning

var _burn_turns_max : int
var _burn_turns := 0

func _ready() -> void:
	assert(burn_turns_min > 0, "burn turns need to be >0")
	_offset_time_for_burning_animation()
	_burn_turns_max = globals.rng.randi_range(burn_turns_min, burn_turns_max)

func take_turn() -> int:
	var target_entity : Entity = globals.actor_area.get_at_map_pos(get_map_pos())
	if target_entity:
		var hit := Hit.new(damage)
		target_entity.take_damage(hit, self)
		if target_entity != globals.player_entity:
			globals.console.print_line(target_entity.display_name + " takes " + str(hit.damage) + " damage from fire.")
		if !target_entity.is_alive():
			globals.console.print_line(target_entity.display_name + " burns to death.")
	_burn_turns += 1
	if _burn_turns_max == _burn_turns:
		remove()
	return speed

func _offset_time_for_burning_animation() -> void:
	_burning.set_material(_burning.get_material().duplicate())
	_burning.get_material().set_shader_param("time_offset", globals.rng.randf_range(0.0, 5.0))
