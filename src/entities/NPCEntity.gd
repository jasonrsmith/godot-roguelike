extends Entity
class_name NPCEntity

onready var _visibility_area: Area2D = $Visibility
onready var _visibility_shape = $Visibility/CollisionShape2D

var _player_in_area = false
var _player_seen = false
var _target_pos : Vector2 = Vector2()

export(int) var visibility_radius = 10
export(bool) var debug_sight = true

var _player_detector_ray: RayCast2D

func _ready():
	events.connect("player_moved", self, "_on_player_moved")
	var shape = CircleShape2D.new()
	shape.radius = globals.map_cell_size * visibility_radius
	_visibility_shape.set_shape(shape)
	_visibility_area.connect("body_entered", self, "_on_Visibility_body_entered")
	_visibility_area.connect("body_exited", self, "_on_Visibility_body_exited")
	_player_detector_ray = RayCast2D.new()
	add_child(_player_detector_ray)

func run_action(name: String, params: Dictionary):
	pass

func _physics_process(delta):
	if !_player_in_area:
		if _player_seen:
			_player_seen = false
			_on_player_lost(globals.player_entity)
		return
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(self.position, globals.player_entity.position, [self], collision_mask)
	if !result:
		return
	_target_pos = result.position
	if result.collider == globals.player_entity and !_player_seen:
		_player_seen = true
		_on_player_seen(globals.player_entity)
	elif result.collider != globals.player_entity && _player_seen:
		_player_seen = false
		_on_player_lost(globals.player_entity)
	update()

func _on_player_seen(player_entity: PlayerEntity):
	pass

func _on_player_lost(player_entity: PlayerEntity):
	pass

func _on_player_moved(world_pos: Vector2) -> void:
	if !_player_in_area:
		return

func _on_Visibility_body_entered(body):
	if body == globals.player_entity:
		_player_in_area = true

func _on_Visibility_body_exited(body):
	update()
	if body == globals.player_entity:
		_player_in_area = false

func _draw():
	if _player_in_area and debug_sight:
		draw_line(Vector2(), (_target_pos - position).rotated(-rotation), globals.LASER_COLOR, 2)
		draw_circle((_target_pos - position).rotated(-rotation), 3, globals.LASER_COLOR)
		draw_circle(Vector2(), _visibility_shape.get_shape().get_radius(), Color(0.9, 0.9, 0.9, 0.1))
