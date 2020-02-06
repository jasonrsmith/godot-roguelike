extends KinematicBody2D
class_name Entity

export var stats : Resource
onready var pivot : Node2D = $Pivot
onready var sprite : Sprite = $Pivot/Sprite
onready var tween : Tween = $Tween
onready var tooltip  = $TooltipCanvas/Tooltip

export (String) var display_name := "thing"

func _ready() -> void:
	tooltip.set_entity(self)
	set_process(false)
	stats = stats.copy()
	stats.reset()
	stats.connect("health_depleted", self, "_on_health_depleted")
	#stats.connect("health_changed", self, "_on_health_changed")


func move_to_map_pos(target_map_pos: Vector2) -> void:
	set_process(false)
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


func bump() -> void:
	#print_debug("bump")
	set_process(false)
	# TODO: tween / anim
	set_process(true)


# TODO: yield doesn't work when dead
func take_damage(hit: Hit, _from: Object) -> void:
	stats.take_damage(hit)
	if !stats.is_alive:
		globals.board.remove_entity(self)
	for i in range(4):
		self.modulate.a = 0.5
		self.modulate.r = 2.0
		self.modulate.g = 0.1
		self.modulate.b = 0.1
		yield(get_tree(), "idle_frame")
		self.modulate.a = 1.0
		self.modulate.r = 1.0
		self.modulate.g = 1.0
		self.modulate.b = 1.0
		yield(get_tree(), "idle_frame")
	if !stats.is_alive:
		remove()

func remove():
	hide()
	queue_free()

func _on_collide_with_entity(entity: Entity):
	print_debug(str(self) + " collides with " + str(entity))

func _on_health_depleted():
	pass
