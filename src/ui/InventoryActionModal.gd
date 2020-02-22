extends Control
class_name InventoryActionModal

onready var _list_container : VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/ListMargin/ListContainer
onready var _title_label : Label = $PanelContainer/MarginContainer/VBoxContainer/HeaderMargin/HBoxContainer/Title

onready var _list_item = preload("res://src/ui/EntityListItem.tscn")

var _item_hotkeys := {}
var _entity : Entity

func _ready() -> void:
	globals.inventory_action_modal = self

func show_entity(entity: Entity) -> void:
	_clear_list()
	_entity = entity
	_title_label.set_text(_entity.display_name.capitalize())
	if entity.has_method("drop"):
		_add_menu_option("[d]", "Drop")
	if entity.has_method("use"):
		_add_menu_option("[u]", "Use")
	if entity.has_method("equip"):
		_add_menu_option("[e]", "Equip")
	yield(get_tree(), "idle_frame")
	show()
	yield(get_tree(), "idle_frame")
	globals.character_info_modal.disable()

func close() -> void:
	events.emit_signal("inventory_action_modal_closed")
	hide()

func _add_menu_option(shortcut: String, description: String) -> void:
	var item : EntityListItem = _list_item.instance()
	_list_container.add_child(item)
	item.init(description, null, shortcut)

func _clear_list() -> void:
	for child in _list_container.get_children():
		child.queue_free()
	yield(get_tree(), "idle_frame")
	rect_size.y = 0
	yield(get_tree(), "idle_frame")

func _unhandled_input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	if not event is InputEventKey:
		return
	if event.is_action_pressed("ui_cancel"):
		globals.character_info_modal.show()
		close()
	get_tree().set_input_as_handled()

	if event.is_action_pressed("ui_use") and _entity.has_method("use"):
		var target : Entity

		globals.character_info_modal.close()
		close()

		if _entity.has_method("use_on"):
			var target_promise : Promise = globals.player_entity.acquire_target(_entity.max_range)
			yield(target_promise, "done")
			target = target_promise.response.result

		globals.player_entity.set_action(
			globals.player_entity.ACTION.USE,
			{"entity": _entity, "target": target})

		# XXX HACK: prevent "u" movement PlayerInput key from conflicting with "use"
		globals.player_input._timer.start(0.3)
		events.emit_signal("player_acted")

	if event.is_action_pressed("ui_drop") and _entity.has_method("drop"):
		# see if we need to pickup an item in the area
		var item : Entity = globals.item_area.get_item_at_map_pos(globals.player_entity.get_map_pos())
		if (item):
			globals.player_entity.backpack.add_entity(item)
			globals.item_area.remove_item(item)
			item.hide()

		globals.player_entity.backpack.remove_entity(_entity)
		_entity.set_map_pos(globals.player_entity.get_map_pos())
		globals.item_area.add_item(_entity)
		globals.character_info_modal.close()
		close()

