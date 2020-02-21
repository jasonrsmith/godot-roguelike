extends Reference
class_name Promise

var request
var response : PromiseResponse

class PromiseResponse:
	var error : int = OK
	var request
	var result

signal done(response)

func _init(request):
	self.request = request

func complete(result, error = OK) -> void:
	var response = PromiseResponse.new()
	response.error = error
	response.request = request
	response.result = result
	self.response = response
	emit_signal("done", response)
