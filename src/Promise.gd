extends Reference
class_name Promise

var error : int = OK
var done : bool = false

var request : Dictionary
var response : Dictionary

signal done(response, request)

func _init(request: Dictionary):
	self.request = request

func complete(response: Dictionary) -> void:
	self.response = response
	self.response["error"] = error
	done = true
	emit_signal("done", self.response, self.request)
