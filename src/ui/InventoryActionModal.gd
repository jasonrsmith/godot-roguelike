extends Control
class_name InventoryActionModal

onready var _list_container : VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/ListMargin/ListContainer
onready var _title_label : Label = $PanelContainer/MarginContainer/VBoxContainer/HeaderMargin/HBoxContainer/Title

onready var _list_item = preload("res://src/ui/EntityListItem.tscn")

var _item_hotkeys := {}
var _entity : Entity

func init(entity: Entity) -> void:
	_clear_list()
	_entity = entity
	_title_label.set_text(_entity.display_name.capitalize())
	if entity.has_method("drop"):
		_add_menu_option("[d]", "Drop")
	if entity.has_method("use"):
		_add_menu_option("[u]", "Use")
	if entity.has_method("equip"):
		_add_menu_option("[e]", "Equip")
	show()

func close() -> void:
	events.emit_signal("inventory_action_modal_closed")
	queue_free()

func _add_menu_option(shortcut: String, description: String) -> void:
	var item : EntityListItem = _list_item.instance()
	_list_container.add_child(item)
	item.init(shortcut, description, null)

func _clear_list() -> void:
	for child in _list_container.get_children():
		child.queue_free()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		close()
	
	if not event is InputEventKey:
		return
	
	if event.is_action_pressed("ui_use") and _entity.has_method("use"):
		globals.player_entity.backpack.remove_entity(_entity)
		_entity.use(globals.player_entity)
		close()
	if event.is_action_pressed("ui_drop") and _entity.has_method("drop"):
		globals.player_entity.backpack.remove_entity(_entity)
		_entity.set_map_pos(globals.player_entity.get_map_pos())
		globals.item_area.add_item(_entity)
		close()
	get_tree().set_input_as_handled()
