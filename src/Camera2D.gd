extends Camera2D

const ZOOM_INC = 0.25
const ZOOM_MIN = 0.25
const ZOOM_DEFAULT = 0.5

var _drag = false
export (bool) var move_camera_enabled
export (float) var pan_sensitivity = 10.0
export (float) var pinch_sensitivity = 1.0

var _shake_timer = 0
var _shake_max_mag
var _shake_mag
var _is_shaking : bool = false

func _ready() -> void:
	globals.camera = self

func _process(delta):
	if _is_shaking:
		if _shake_timer > 0:
			set_offset(Vector2(
				globals.rng.randf_range(-1.0, 1.0) * _shake_mag,
				globals.rng.randf_range(-1.0, 1.0) * _shake_mag))
			_shake_timer -= delta
			_shake_mag = _shake_timer * _shake_max_mag
		else:
			set_offset(Vector2(0, 0))
			_is_shaking = false

func shake(duration, magnitude):
	# don't shake if already offset
	if get_offset() != Vector2():
		return

	_is_shaking = true
	_shake_max_mag = magnitude
	_shake_timer = duration
	_shake_mag = _shake_timer * magnitude

func _input(event: InputEvent) -> void:
	if !move_camera_enabled:
		return
	if event.is_action_pressed("ui_zoom_out"):
		set_zoom(get_zoom() + Vector2.ONE * ZOOM_INC)
	elif event.is_action_pressed("ui_zoom_in") and get_zoom() > Vector2.ONE * ZOOM_MIN:
		set_zoom(get_zoom() - Vector2.ONE * ZOOM_INC)
	elif event.is_action_pressed("ui_zoom_reset"):
		set_zoom(Vector2.ONE * ZOOM_DEFAULT)
		set_offset(Vector2())
	elif event.is_action_pressed("ui_cam_drag"):
		_drag = true
	elif event.is_action_released("ui_cam_drag"):
		_drag = false
	elif event is InputEventMouseMotion && _drag:
		set_offset(get_offset() - event.relative * get_zoom().x)
	elif event is InputEventMagnifyGesture:
		set_zoom(get_zoom() / event.factor * pinch_sensitivity)
	elif event is InputEventPanGesture:
		set_offset(get_offset() + event.delta * pan_sensitivity * get_zoom().x)
