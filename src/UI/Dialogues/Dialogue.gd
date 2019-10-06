extends Node2D

export(float) var TIME_TO_SHOW_TEXT = 2.0
export(float) var STAY_DURATION = 3.0

onready var dialogue_label = $Label

var is_finished = false
var is_showing = false

var stay_tick = 0.0

func _ready() -> void:
	visible = false

func _process(delta: float) -> void:
	if not visible:
		return

	if not is_finished:
		var step = 1.0 / TIME_TO_SHOW_TEXT
		dialogue_label.percent_visible += delta * step
		if dialogue_label.percent_visible >= 1:
			is_finished = true
	else:
		stay_tick += delta
		if stay_tick >= STAY_DURATION:
			visible = false
		

func set_text(text, duration) -> void:
	print_debug(text)
	visible = true
	STAY_DURATION = duration
	dialogue_label.text = text
	dialogue_label.percent_visible = 0.0
	is_finished = false
	stay_tick = 0.0
	