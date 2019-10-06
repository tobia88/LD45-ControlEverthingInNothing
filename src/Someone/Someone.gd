extends KinematicBody2D

export(float) var MOVE_SPD = 100

var target_node
var velocity = Vector2.ZERO
var is_grounding = false
var current_trigger = null
var is_facing_left = false setget set_is_facing_left

onready var dialogue = $Dialogue 

func _ready() -> void:
	Events.connect("on_trigger_dialogue", self, "on_trigger_diaglue")
	Events.connect("someone_trigger_something", self, "on_someone_trigger_something")

func jump(velocity: Vector2) -> void:
	print_debug("is_grounding:%s"%is_grounding)
	if not is_grounding:
		return
		
	self.velocity = velocity

func set_is_facing_left(value) -> void:
	if is_facing_left == value:
		return
	is_facing_left = value
	set_flip_h(is_facing_left)

func on_someone_trigger_something(trigger) -> void:
	current_trigger = trigger
	trigger.apply(self)

func _physics_process(delta: float) -> void:
	
	velocity.y += GameData.GRAVITY
	
	move_and_slide(velocity, Vector2(0.0, -1.0))
	"""
	if player not jumping, then move towards the target
	"""	
	
	is_grounding = is_on_floor()
	
	if current_trigger != null and current_trigger.check_finished(self):
		Events.emit_signal("someone_finished_something", current_trigger)
		current_trigger = null
		
	
	if is_grounding:
		velocity.y = 0.0
		
		target_node = null
		for trigger_node in get_tree().get_nodes_in_group("someone_triggable"):
			if trigger_node.detect_condition(self):
				if target_node == null or trigger_node.PICK_PRIORITY > target_node.PICK_PRIORITY:
					target_node = trigger_node

		if target_node == null:
			velocity.x = 0.0
		else:
			var dist_x = target_node.global_position.x - global_position.x
			if abs(dist_x) >= 1:
				velocity.x = sign(dist_x) * MOVE_SPD 
			else:
				velocity.x = 0.0
	
	if velocity.x != 0:
		set_is_facing_left(velocity.x < 0)
		
	$DebugLabel.text = "Vel:%s"%velocity
	$DebugLabel.text += "\nIs Gounding:%s"%is_grounding
	if target_node != null:
		$DebugLabel.text += "\nTarget Node%s"%target_node.name

func set_flip_h(result) -> void:
	$Body/BodyImgNormal.flip_h = result
	$Body/BodyImgShadow.flip_h = result
				
func on_trigger_diaglue(trigger) -> void:
	dialogue.set_text(trigger[0], trigger[1])
