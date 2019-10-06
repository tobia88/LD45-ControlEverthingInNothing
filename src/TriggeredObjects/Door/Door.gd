extends "res://src/TriggeredObjects/SomeoneTriggableObject.gd"

func do_right_thing(someone) -> void:
	Events.emit_signal("someone_entered_door", someone)