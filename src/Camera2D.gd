extends Camera2D

const ZOOM_INC = 0.25
const ZOOM_MIN = 0.25
const ZOOM_DEFAULT = 0.5

var _drag = false
export (bool) var move_camera_enabled

func _ready() -> void:
	globals.camera = self

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