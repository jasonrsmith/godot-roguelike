extends MainLoop

func _init():
	hello()
	get_tree().quit()

func hello():
	print_debug("hello")
