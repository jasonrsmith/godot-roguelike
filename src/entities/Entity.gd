extends KinematicBody2D
class_name Entity

onready var pivot : Node2D = $Pivot
onready var sprite : Sprite = $Pivot/Sprite
onready var tween : Tween = $Tween

func _ready() -> void:
	set_process(false)
	pass

func move_to_map_pos(target_map_pos: Vector2) -> void:
	set_process(false)
	#camera.set_process(false)
	var world_pos : Vector2 = globals.board.map_to_world(target_map_pos) \
		+ (globals.map_cell_size * Vector2.ONE / 2)
	var move_direction : Vector2 = (world_pos - position).normalized()
	position = world_pos
	pivot.position = -1 * move_direction * 8.0
	tween.interpolate_property(pivot, "position", pivot.position, Vector2(), 0.08, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	tween.start()
	set_process(true)
	if move_direction == Vector2.LEFT:
		sprite.set_flip_h(true)
	elif move_direction == Vector2.RIGHT:
		sprite.set_flip_h(false)
	#camera.set_enable_follow_smoothing(true)


func bump() -> void:
	#print_debug("bump")
	set_process(false)
	# TODO: tween / anim
	set_process(true)
