extends Node2D

enum RUN_STATE { RUNNING, PAUSED }

var _run_state = RUN_STATE.PAUSED
var _tick = 0
var _queue = []

export(bool) var debug_actions = false

class Action:
	var obj: Object
	var cost: int
	var action_name: String
	var params: Dictionary
	var completion_time: int

	func _init(obj: Object, cost: int, action_name: String, params: Dictionary, completion_time):
		self.obj = obj
		self.cost = cost
		self.action_name = action_name
		self.params = params
		self.completion_time = completion_time

func _process(delta):
	if _run_state == RUN_STATE.RUNNING:
		run_actions()

func run_actions() -> void:
	while _run_state == RUN_STATE.RUNNING and _queue.size() > 0:
		var next_action = _queue.pop_front()
		_tick = next_action.completion_time
		if debug_actions:
			print_debug(next_action.action_name, " ", next_action.obj.name, " ", _tick)
		next_action.obj.run_action(next_action.action_name, next_action.params)

func queue_action(obj, cost, action_name, params) -> void:
	var action = Action.new(obj, cost, action_name, params, cost + _tick)
	var insertion_point = _queue.bsearch_custom(action, self, "compare_actions")
	_queue.insert(insertion_point, action)
	globals.debug_canvas.print_line(str(cost + _tick) + " " + obj.name + " " + action_name)

func compare_actions(a: Action, b: Action):
	return a.completion_time < b.completion_time

func pause() -> void:
	_run_state = RUN_STATE.PAUSED

func unpause() -> void:
	_run_state = RUN_STATE.RUNNING