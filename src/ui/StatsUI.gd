extends MarginContainer
class_name StatsUI

onready var _hp_label: Label = $VBoxContainer/HP

func _ready():
	events.connect('player_health_changed', self, '_on_PlayerEntity_health_changed')

func update_hp(current_hp: int, max_hp: int) -> void:
	_hp_label.set_text("HP: " + str(current_hp) + " / " + str(max_hp))

func _on_PlayerEntity_health_changed(health: int, old_health: int):
	update_hp(globals.player_entity.stats.health, globals.player_entity.stats.max_health)
