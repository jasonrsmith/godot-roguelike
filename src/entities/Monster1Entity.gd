extends Entity
class_name Monster1Entity

onready var _visibility_area: Area2D = $Visibility
onready var _visibility_shape = $Visibility/CollisionShape2D

func _ready():
	events.connect("player_moved", self, "_on_player_moved")
	var shape = CircleShape2D.new()
	shape.radius = globals.map_cell_size * 10
	_visibility_shape.set_shape(shape)
	_visibility_area.connect("body_entered", self, "_on_Visibility_body_entered")

func _on_player_moved(world_pos: Vector2) -> void:
	pass

func _on_Visibility_body_entered(body):
	print_debug("body entered ", body)
	print_debug(typeof(body))