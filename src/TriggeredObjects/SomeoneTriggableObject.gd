extends Area2D

var is_triggering: bool = false setget set_is_triggered
var is_activating: bool = false

var detection: bool = false

export(int) var PICK_PRIORITY: int = 3
export(Array) var CONDITION
export(Array) var DETECT_CONDITION

var holding_body = null
var freeze = false
var last_condition = false

export(String, MULTILINE) var DIALOG_TEXT = ""
export(String, MULTILINE) var FALSE_DIALOG_TEXT = ""
export(float) var STAY_DURATION = 1.0
export(bool) var PREVENT_RESET_ACTIVATION = false
	
func do_right_thing(player) -> void:
	if DIALOG_TEXT != "":
		Events.emit_signal("on_trigger_dialogue",[DIALOG_TEXT, STAY_DURATION])

func do_bad_thing(player) -> void:
	if FALSE_DIALOG_TEXT != "":
		Events.emit_signal("on_trigger_dialogue",[FALSE_DIALOG_TEXT, STAY_DURATION])

func _ready() -> void:
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")
	Events.connect("someone_finished_something", self, "on_someone_finished_something")

func detect_condition(player) -> bool:
	detection = test_conditions(player, DETECT_CONDITION)
	return is_triggering && detection

func _process(delta: float) -> void:
	
	"""
	Check if covered in lights
	"""
	var overlapings = get_overlapping_areas()
	
	var result = false
	
	for o in overlapings:
		if o.is_in_group("light") and o.is_triggering:
			result = true
			break
	
	set_is_triggered(result)
	
	if holding_body == null:
		last_condition = false
		
		if not PREVENT_RESET_ACTIVATION:
			is_activating = false
		return
	
	"""
	Check if match conditions and activation
	"""
	var new_condition =  check_conditions(holding_body)

	apply(new_condition, holding_body)

func set_is_triggered(value) -> void:
	if value == is_triggering:
		return

	is_triggering = value

func on_body_entered(body: PhysicsBody2D) -> void:
	if body == null:
		return

	if body.is_in_group("someone"):
		holding_body = body

func apply(condition, player) -> void:
	if is_activating and condition == last_condition:
		return

	if condition:
		do_right_thing(player)
	else:
		do_bad_thing(player)
	
	last_condition = condition
	is_activating = true

func check_conditions(player) -> bool:
	return test_conditions(player, CONDITION)

func test_conditions(player, conditions):
	if conditions == null or conditions.size() == 0:
		return true

	for c in conditions:
		if c == null or not c is NodePath or c == "":
			continue
			
		var node = get_node(c)
		if not node.condition(self, player):
			return false

	return true
func on_body_exited(body: PhysicsBody2D) -> void:
	if body == null:
		return

	if body == holding_body:
		holding_body = null
		set_is_triggered(false)

func on_someone_finished_something(trigger) -> void:
	pass