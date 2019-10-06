extends "res://src/TriggeredObjects/Conditions/BaseCondition.gd"

export(Array) var CONDITION
export(bool) var TEST_RESULT = true

func condition(parent, player) -> bool:
	if CONDITION == null or CONDITION.size() == 0:
		return true

	for c in CONDITION:
		if c == null:
			continue

		var node = get_node(c)
		if not node.is_activating == TEST_RESULT:
			return false

	return true