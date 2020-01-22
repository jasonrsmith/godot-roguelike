extends Entity
class_name Monster1Entity

onready var _visibility_area: Area2D = $Visibility
onready var _visibility_shape = $Visibility/CollisionShape2D

var _player_in_view = false
var _target_pos : Vector2 = Vector2()

func _ready():
	events.connect("player_moved", self, "_on_player_moved")
	var shape = CircleShape2D.new()
	shape.radius = globals.map_cell_size * 10
	_visibility_shape.set_shape(shape)
	_visibility_area.connect("body_entered", self, "_on_Visibility_body_entered")
	_visibility_area.connect("body_exited", self, "_on_Visibility_body_exited")

func _physics_process(delta):
	if !_player_in_view:
		return
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(self.position, globals.player_entity.position, [self], collision_mask)
	if result:
		_target_pos = result.position
	update()


func _on_player_moved(world_pos: Vector2) -> void:
	pass

func _on_Visibility_body_entered(body):
	if body == globals.player_entity:
		_player_in_view = true

func _on_Visibility_body_exited(body):
	update()
	if body == globals.player_entity:
		_player_in_view = false

func _draw():
	if _player_in_view:
		draw_line(Vector2(), (_target_pos - position).rotated(-rotation), globals.LASER_COLOR, 2)
		draw_circle((_target_pos - position).rotated(-rotation), 3, globals.LASER_COLOR)
