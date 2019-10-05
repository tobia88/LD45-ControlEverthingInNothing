extends Node

const MAX_TRIGGER_PHASE = 5

var key_count: int = 1
var key_pressed : int = 0
var total_power: int = 0

func get_power_ratio() -> float:
	return float(key_pressed - 1) / float(MAX_TRIGGER_PHASE - 1)