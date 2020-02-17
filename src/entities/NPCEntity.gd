extends Entity
class_name NPCEntity

onready var _visibility_area: Area2D = $Visibility
onready var _visibility_shape = $Visibility/CollisionShape2D

var _player_in_area = false
var _player_seen = false
var _target_pos : Vector2 = Vector2()
var _path_to_player : Array = []
var _hostile_to_player = true

var visibility_radius : int

var _player_detector_ray: RayCast2D
var _path_green_color : float

func _ready():
	globals.time_manager.register(self)
	visibility_radius = stats.sight
	var shape = CircleShape2D.new()
	shape.radius = globals.map_cell_size * visibility_radius
	_visibility_shape.set_shape(shape)
	_visibility_area.connect("body_entered", self, "_on_Visibility_body_entered")
	_visibility_area.connect("body_exited", self, "_on_Visibility_body_exited")
	_player_detector_ray = RayCast2D.new()
	add_child(_player_detector_ray)
	_path_green_color = rand_range(0.6, 0.99)

func take_turn() -> int:
	if !_player_in_area:
		set_physics_process(false)
		return stats.speed
	set_physics_process(true)
	if _player_seen or _path_to_player.size() > 1:
		var map_pos = globals.board.world_to_map(globals.player_entity.position)
		if globals.board.world_to_map(position).distance_to(map_pos) < 1.5:
			execute_attack(globals.player_entity)
		else:
			execute_move_toward_player()
		return 100
	return stats.speed

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
	if result.collider == globals.player_entity:
		refresh_target_path(globals.board.world_to_map(globals.player_entity.position))
	if result.collider == globals.player_entity and !_player_seen:
		_player_seen = true
		_on_player_seen(
			globals.board.world_to_map(globals.player_entity.position))
	elif result.collider != globals.player_entity && _player_seen:
		_player_seen = false
		_on_player_lost(
			globals.board.world_to_map(globals.player_entity.position))
	update()

func _on_player_seen(map_pos: Vector2) -> void:
	pass

func _on_player_lost(map_pos: Vector2) -> void:
	pass

func execute_move_toward_player():
	if _path_to_player.size() <= 1:
		return
	var current_map_pos_v3 : Vector3 = _path_to_player.pop_front()
	var current_map_pos := Vector2(current_map_pos_v3.x, current_map_pos_v3.y)
	var target_map_pos := Vector2(_path_to_player[0].x, _path_to_player[0].y)
	var direction = (target_map_pos - current_map_pos)
	target_map_pos = globals.board.request_move(self, direction)
	if target_map_pos != Vector2():
		move_to_map_pos(target_map_pos)

func execute_attack(entity: Entity):
	var hit = Hit.new(stats.strength)
	entity.take_damage(hit, self)

func refresh_target_path(map_pos: Vector2):
	var surrounding_entities : Array = globals.board.get_entities_surrounding_map_pos(map_pos)
	
	# enable surrounding entities for flanking
	for entity_map_pos in surrounding_entities:
		if entity_map_pos == globals.board.world_to_map(globals.player_entity.position):
			continue
		globals.board.set_point_disabled_for_path(entity_map_pos)
	
	_path_to_player = globals.board.find_path(globals.board.world_to_map(position), map_pos)
	
	# re-enable surrounding entities
	for entity_map_pos in surrounding_entities:
		if entity_map_pos == globals.board.world_to_map(globals.player_entity.position):
			continue
		globals.board.set_point_disabled_for_path(entity_map_pos, false)

func _on_Visibility_body_entered(body):
	if body == globals.player_entity:
		_player_in_area = true

func _on_Visibility_body_exited(body):
	update()
	if body == globals.player_entity:
		_player_in_area = false

func _draw():
	if !globals.debug_settings.show_enemy_sight:
		return
	if _player_in_area:
		draw_line(Vector2(), (_target_pos - position).rotated(-rotation), globals.LASER_COLOR, 2)
		draw_circle((_target_pos - position).rotated(-rotation), 3, globals.LASER_COLOR)
		draw_circle(Vector2(), _visibility_shape.get_shape().get_radius(), Color(0.9, 0.9, 0.9, 0.1))
	if _path_to_player.size() > 0:
		for p in _path_to_player:
			var world_pos = globals.board.map_to_world(Vector2(p.x, p.y))
			var rect = Rect2(world_pos - position, globals.map_cell_size * Vector2.ONE)
			draw_rect(rect, Color(0.5, _path_green_color, 0.83, 0.5))
