extends MarginContainer
class_name EntityStats

onready var ProgressBarScene = preload("res://src/ui/ProgressBar.tscn")

onready var _health_progress_bar = $VBoxContainer/HealthProgressBar
onready var _status_effect_bar_list = $VBoxContainer/StatusEffectBars

var _entity : ActorEntity

func init(entity: ActorEntity):
	_entity = entity
	_entity.connect('health_changed', self, '_on_health_changed')
	_entity.connect('status_effects_processed', self, '_on_status_effects_processed')
	update_hp(_entity.health, _entity.max_health)

func update_hp(current_hp: int, max_hp: int) -> void:
	_health_progress_bar.set_value(100 * current_hp / max_hp)

func _on_health_changed(health: int, old_health: int):
	update_hp(globals.player_entity.health, globals.player_entity.max_health)

func _on_status_effects_processed(status_effects: Array):
	for child in _status_effect_bar_list.get_children():
		child.queue_free()
	for effect in status_effects:
		var bar = ProgressBarScene.instance()
		_status_effect_bar_list.add_child(bar)
		bar.set_text(effect.display_name)
		bar.set_value(100 - 100 * effect.turns_taken / effect.max_turns)
