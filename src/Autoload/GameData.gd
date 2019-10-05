extends Node

const MAX_TRIGGER_PHASE = 5
const GRAVITY = 150

var key_count: int = 1
var key_pressed : int = 0
var total_power: int = 0

func get_power_ratio() -> float:
	if key_pressed == 0:
		return 0.0
		
	return 1.0 / key_pressed