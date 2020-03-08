extends MarginContainer
class_name EntityStats

onready var _health_progress_bar = $VBoxContainer/HealthProgressBar

var _entity

func init(entity: Entity):
	_entity = entity
	_entity.connect('health_changed', self, '_on_health_changed')
	update_hp(_entity.health, _entity.max_health)

func update_hp(current_hp: int, max_hp: int) -> void:
	_health_progress_bar.set_value(100 * current_hp / max_hp)

func _on_health_changed(health: int, old_health: int):
	update_hp(globals.player_entity.health, globals.player_entity.max_health)
