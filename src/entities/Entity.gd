extends KinematicBody2D
class_name Entity

export var stats : Resource
onready var pivot : Node2D = $Pivot
onready var sprite : Sprite = $Pivot/Sprite
onready var tween : Tween = $Tween
onready var tooltip  = $TooltipCanvas/Tooltip
onready var backpack = $Backpack

export var display_name := "thing"

var _inside_backpack : Backpack

func _ready() -> void:
	set_process(false)
	stats = stats.copy()
	stats.reset()
	update_display_from_stats()
	tooltip.set_entity(self)

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
	if move_direction.x < 0:
		sprite.set_flip_h(true)
	elif move_direction.x > 0:
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
		# TODO refactor to NPCEntity
		globals.npc_area.remove_npc(self)
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

func set_map_pos(map_pos: Vector2):
	position = (globals.board.map_to_world(map_pos) +
		globals.board.cell_size / 2)

func get_map_pos():
	return globals.board.world_to_map(position)

func load_stats(resource_path: String) -> void:
	stats = load(resource_path)

func update_display_from_stats() -> void:
	if "image" in stats:
		sprite.set_texture(stats.image)
	if "display_name" in stats:
		display_name = stats.display_name

func add_entity_to_backpack(entity: Entity) -> void:
	backpack.add_entity(entity)
	entity.hide()
	entity._inside_backpack = backpack

func remove_entity_from_backpack(entity: Entity) -> void:
	backpack.remove_entity(entity)
	entity._inside_backpack = null

func _on_collide_with_entity(entity: Entity):
	print_debug(str(self) + " collides with " + str(entity))
