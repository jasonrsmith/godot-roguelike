extends Node2D
class_name Entity


signal moved(last_pos, current_pos)


onready var pivot : Node2D = $Pivot
onready var sprite : Sprite = $Sprite


export(globals.CELL_TYPES) var type = globals.CELL_TYPES.ACTOR


func _ready() -> void:
	pass


func move_to(target_pos: Vector2) -> void:
	emit_signal("moved", position, target_pos)
	
	set_process(false)
	#var move_direction : Vector2 = (target_pos - position).normalized()
	position = target_pos
	#pivot.position = -1 * move_direction * 16.0
	# TODO: tween / anim
	set_process(true)


func bump() -> void:
	print_debug("bump")
	set_process(false)
	# TODO: tween / anim
	set_process(true)
