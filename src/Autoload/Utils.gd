extends Node

func check_conditions(object, conditions, someone) -> bool:
	if conditions == null or conditions.size() == 0:
		return true

	for c in conditions:
		if c == null:
			continue
			
		var node = object.get_node(c)
		if not node.condition(object, someone):
			return false

	return true