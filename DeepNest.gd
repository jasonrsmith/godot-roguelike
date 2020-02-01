extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


func _enter_tree() -> void:
	print_debug(str(self) + " _enter_tree")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print_debug(str(self) + " _ready")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
