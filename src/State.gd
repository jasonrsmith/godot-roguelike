extends Node2D

enum RUN_STATE { RUNNING, PAUSED }

var _run_state = RUN_STATE.PAUSED
var _tick = 0
var _queue = []

export(bool) var debug_actions = true

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

func cancel_actions_for_obj(obj: Object) -> void:
	globals.debug_canvas.print_line("cancel_actions: " + str(obj))
	globals.debug_canvas.print_line("cancel_actions queue: " + str(_queue))
	var i := 0
	for action in _queue:
		if action.obj == obj:
			_queue.remove(i)
		else:
			i += 1

func run_actions() -> void:
	var pause_tick = globals.max_int
	while _run_state == RUN_STATE.RUNNING and _queue.size() > 0:
		if _queue[0].completion_time > pause_tick:
			pause()
		var next_action = _queue.pop_front()
		if !is_instance_valid(next_action.obj):
			continue
		if next_action.obj is Entity and !next_action.obj.stats._is_alive():
			continue
		_tick = next_action.completion_time
		if debug_actions:
			globals.debug_canvas.print_line(str(next_action.cost + _tick) + " " + next_action.obj.name + " " + next_action.action_name + " " + str(next_action.params), globals.LOG_CAT.DEBUG)
		next_action.obj.run_action(next_action.action_name, next_action.params)
		if next_action.obj == globals.player_input:
			pause_tick = next_action.completion_time
			events.emit_signal("player_acted")

func queue_action(obj, cost, action_name, params) -> void:
	var action = Action.new(obj, cost, action_name, params, cost + _tick)
	var insertion_point = _queue.bsearch_custom(action, self, "compare_actions")
	_queue.insert(insertion_point, action)

func compare_actions(a: Action, b: Action):
	return a.completion_time < b.completion_time

func pause() -> void:
	_run_state = RUN_STATE.PAUSED

func unpause() -> void:
	_run_state = RUN_STATE.RUNNING
