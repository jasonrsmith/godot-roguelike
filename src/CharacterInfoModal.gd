extends CanvasLayer
class_name CharacterInfoModal

onready var _list_item = preload("res://src/ui/EntityListItem.tscn")
onready var _inventory_action_modal = preload("res://src/ui/InventoryActionModal.tscn")

onready var _control : PanelContainer = $PanelContainer
onready var _title_label : Label = $PanelContainer/MarginContainer/VBoxContainer/HeaderMargin/HBoxContainer/Title
onready var _list_container : VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/ListMargin/ListContainer

enum SCREEN_TYPE { INVENTORY, DROP, DRINK }

var _recalc_height_required := false
var _current_screen

const SHORTCUT_LIST = "abcdefghijklmnopqrstuvwxyz0123456789"

var _item_hotkeys = {}

func _ready() -> void:
	globals.character_info_modal = self

func show_inventory():
	_current_screen = SCREEN_TYPE.INVENTORY
	_title_label.set_text("Backpack")
	var backpack_entities = globals.player_entity.backpack.get_all_entities()
	_clear_list()
	if backpack_entities.size() == 0:
		var label : Label = Label.new()
		label.set_text("(empty)")
		_list_container.add_child(label)
	
	var idx := 0
	for entity in backpack_entities:
		var item = _list_item.instance()
		var hotkey := SHORTCUT_LIST.substr(idx, 1)
		_list_container.add_child(item)
		item.init(
			"[" + hotkey + "]",
			entity.display_name,
			entity.sprite.get_texture()
		)
		_item_hotkeys[hotkey] = entity
		idx += 1
	_control.show()

func _clear_list() -> void:
	for child in _list_container.get_children():
		child.queue_free()

func _show_inventory_actions(entity: Entity) -> void:
	var modal : InventoryActionModal = _inventory_action_modal.instance()
	add_child(modal)
	modal.init(entity)

func _unhandled_input(event: InputEvent) -> void:
	if !_control.is_visible_in_tree():
		return
	if event.is_action_pressed("ui_cancel"):
		_control.hide()
	if event is InputEventKey:
		var hotkey : String = char(event.scancode+32)
		if _item_hotkeys.has(hotkey):
			var entity = _item_hotkeys[hotkey]
			match _current_screen:
				SCREEN_TYPE.INVENTORY:
					_show_inventory_actions(entity)
	get_tree().set_input_as_handled()
