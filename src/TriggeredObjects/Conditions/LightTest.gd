extends "res://src/TriggeredObjects/Conditions/BaseCondition.gd"

export(Array) var CONDITION

func condition(parent, player) -> bool:
	
	if CONDITION == null or CONDITION.size() == 0:
		return true
	
	
	for c in CONDITION:
		if c == null:
			continue

		var node = get_node(c)
		if not node.is_triggering:
			return false
	
	return true