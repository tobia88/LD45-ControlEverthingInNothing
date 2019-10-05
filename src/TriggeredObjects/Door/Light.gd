extends Area2D

export(String) var input_key
export(Curve) var input_phase
export(int) var PICK_PRIORITY

var max_scale: float = 0
var is_triggering: bool = false setget set_is_triggering

onready var circle_shape : CollisionShape2D = $CollisionShape2D
onready var light : Light2D = $LightBody/Light2D

func _ready() -> void:
	max_scale = light.scale.x
	
	set_is_triggering(false)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(input_key):
		set_is_triggering(true)
	elif event.is_action_released(input_key):
		set_is_triggering(false)

func _process(delta: float) -> void:
	update_power()

func update_power() -> void:
	var percentage = input_phase.interpolate(GameData.get_power_ratio())
	var tmp_scale: float = lerp(0.0, max_scale, percentage)
	
	light.enabled = is_triggering
	
	if is_triggering:
		light.scale = Vector2(tmp_scale, tmp_scale)
	
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