extends Node2D

onready var _popup_menu : PopupMenu = $PopupMenu

func _ready():
	_popup_menu.add_item("does this")
	_popup_menu.add_item("does that")
	_popup_menu.connect("id_pressed", self, "_on_item_pressed")

func _input(event):
	if event is InputEventKey and event.scancode == KEY_A:
		_popup_menu.show()

func _on_item_pressed(ID):
	print(_popup_menu.get_item_text(ID), " pressed")
