extends Area2D
	
export(String) var input_key
export(Curve) var input_phase

export(bool) var PREVENT_POWER_DECAY = false
export(bool) var IS_RADIAL_LIGHT: bool = true

export(Vector2) var FROM_POINT = Vector2.ZERO
export(Vector2) var TO_POINT = Vector2(0.0, 10.0)
export(float, 0.0, 1.0) var percentage = 0.0
export(float) var MOVE_SPD = 100

var global_from_point: Vector2
var global_to_point: Vector2

var current_from: Vector2
var current_to: Vector2

var is_reversed = false

onready var start_pos = global_position
onready var light = $Light2D

func _ready() -> void:
	max_scale = light.scale.y
	set_is_triggering(false)

func _process(delta: float) -> void:
	update_power()

var max_scale: float = 0
var is_triggering: bool = false setget set_is_triggering

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(input_key):
		set_is_triggering(true)
	elif event.is_action_released(input_key):
		set_is_triggering(false)

func update_power() -> void:
	var ratio = 1.0 if PREVENT_POWER_DECAY else GameData.get_power_ratio()
	var interpolated = input_phase.interpolate(ratio)
	
	if is_triggering:
		var tmp_spd: float = lerp(0.0, MOVE_SPD, interpolated)
		
		global_from_point = start_pos + FROM_POINT
		global_to_point = start_pos + TO_POINT
		
		current_from = global_to_point if is_reversed else global_from_point
		current_to = global_from_point if is_reversed else global_to_point
		
		percentage += tmp_spd/10000
		
		var final_percent = smoothstep(0.0, 1.0, percentage)
		var p = lerp(current_from, current_to, final_percent)
		
		if percentage >= 1.0:
			percentage -= 1.0
			is_reversed = !is_reversed
		
		global_position = p
	
	light.enabled = is_triggering
	
	if is_triggering:
		var tmp_scale = lerp(0.0, max_scale, interpolated)
		if IS_RADIAL_LIGHT:
			light.scale = Vector2(tmp_scale, tmp_scale)
		else:
			light.scale = Vector2(light.scale.x, tmp_scale)
	
func set_is_triggering(value: bool) -> void:
	if is_triggering == value:
		return
	
	is_triggering = value
	
	if is_triggering:
		GameData.key_pressed += 1
		Events.emit_signal("on_start_trigger", self)
	else:
		GameData.key_pressed -= 1
		Events.emit_signal("on_stop_trigger", self)