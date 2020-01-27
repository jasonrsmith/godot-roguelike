extends Entity
class_name NPCEntity

onready var _visibility_area: Area2D = $Visibility
onready var _visibility_shape = $Visibility/CollisionShape2D

var _player_in_area = false
var _player_seen = false
var _target_pos : Vector2 = Vector2()
var _path_to_player : Array = []

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
	if name == "move_in_direction":
		var direction = params.direction
		print_debug("want to move: ", direction)
		var target_map_pos = globals.board.request_move(self, direction)
		if target_map_pos != Vector2():
			move_to_map_pos(target_map_pos)

func _physics_process(delta):
	if !_player_in_area:
		if _player_seen:
			_player_seen = false
			_on_player_lost(
				globals.board.world_to_map(globals.player_entity.position))
		return
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(self.position, globals.player_entity.position, [self], collision_mask)
	if !result:
		return
	_target_pos = result.position
	if result.collider == globals.player_entity and !_player_seen:
		_player_seen = true
		_on_player_seen(
			globals.board.world_to_map(globals.player_entity.position))
	elif result.collider != globals.player_entity && _player_seen:
		_player_seen = false
		_path_to_player = []
		_on_player_lost(
			globals.board.world_to_map(globals.player_entity.position))
	update()

func _on_player_seen(map_pos: Vector2) -> void:
	_on_player_moved(map_pos)

func _on_player_lost(map_pos: Vector2) -> void:
	pass

func _on_player_moved(map_pos: Vector2) -> void:
	if !_player_in_area:
		set_physics_process(false)
		return
	set_physics_process(true)
	if _player_seen:
		_path_to_player = globals.board.find_path(globals.board.world_to_map(position), map_pos)
		if _path_to_player.size() <= 1:
			return
		var current_map_pos_v3 : Vector2 = _path_to_player.pop_front()
		var current_map_pos := Vector2(current_map_pos_v3.x, current_map_pos_v3.y)
		var target_map_pos := Vector2(_path_to_player[0].x, _path_to_player[0].y)
		var direction = (target_map_pos - current_map_pos)
		run_action("move_in_direction", 
			{"direction": direction})
		#State.queue_action(self, 100, "move_in_direction", 
		#	{"direction": direction})


func _on_Visibility_body_entered(body):
	if body == globals.player_entity:
		_player_in_area = true

func _on_Visibility_body_exited(body):
	update()
	if body == globals.player_entity:
		_player_in_area = false

func _draw():
	if !debug_sight:
		return
	if _player_in_area:
		draw_line(Vector2(), (_target_pos - position).rotated(-rotation), globals.LASER_COLOR, 2)
		draw_circle((_target_pos - position).rotated(-rotation), 3, globals.LASER_COLOR)
		draw_circle(Vector2(), _visibility_shape.get_shape().get_radius(), Color(0.9, 0.9, 0.9, 0.1))
	if _player_seen and _path_to_player.size() > 0:
		for p in _path_to_player:
			var world_pos = globals.board.map_to_world(Vector2(p.x, p.y))
			var rect = Rect2(world_pos - position, globals.map_cell_size * Vector2.ONE)
			draw_rect(rect, Color(0.5, 1, 0.83, 0.5))
