extends "res://src/TriggeredObjects/SomeoneTriggableObject.gd"

export(Array) var CONTROL_OBJECT

func do_right_thing(someone) -> void:
	.do_right_thing(someone)
	
	if CONTROL_OBJECT == null:
		return
	
	for n in CONTROL_OBJECT:
		if n == null:
			continue
		
		get_node(n).is_triggering = true
	
	is_activating = true

func detect_condition(player) -> bool:
	if not .detect_condition(player):
		return false
	
	print_debug(name + " " + str(is_activating))
	
	return not is_activating