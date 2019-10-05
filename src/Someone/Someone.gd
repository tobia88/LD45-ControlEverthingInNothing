extends KinematicBody2D

export(float) var MOVE_SPD = 100

var target_node
var velocity = Vector2.ZERO
var is_grounding = false

func _ready() -> void:
	Events.connect("on_start_trigger", self, "on_trigger_started")
	Events.connect("on_stop_trigger", self, "on_trigger_stopped")

func jump(velocity: Vector2) -> void:
	print_debug("is_grounding:%s"%is_grounding)
	if not is_grounding:
		return
		
	self.velocity = velocity

func _physics_process(delta: float) -> void:
	
	velocity.y += GameData.GRAVITY
	
	move_and_slide(velocity, Vector2(0.0, -1.0))
	"""
	if player not jumping, then move towards the target
	"""	
	
	is_grounding = is_on_floor()
	
	if is_on_floor():
		velocity.y = 0.0
		
		target_node = null
		for trigger_node in get_tree().get_nodes_in_group("triggable"):
			if trigger_node.is_triggering:
				if target_node == null or trigger_node.PICK_PRIORITY > target_node.PICK_PRIORITY:
					target_node = trigger_node

		if target_node == null:
			velocity.x = 0.0
		else:
			var dist_x = target_node.global_position.x - global_position.x
			if abs(dist_x) >= 1:
				velocity.x = sign(dist_x) * MOVE_SPD 
	
	if velocity.x != 0:
		set_flip_h(velocity.x < 0)
		
	$DebugLabel.text = "Vel:%s"%velocity
	$DebugLabel.text += "\nIs Gounding:%s"%is_grounding

func set_flip_h(result) -> void:
	$Body/BodyImgNormal.flip_h = result
	$Body/BodyImgShadow.flip_h = result

func on_trigger_started(node) -> void:
	if target_node == null or target_node != null and node.priority > target_node.priority:
		target_node = node

func on_trigger_stopped(node) -> void:
	print_debug("stop node: " + node.name)
	if target_node == node:
		target_node = null
	
		for light_node in get_tree().get_nodes_in_group("light"):
			if light_node.is_triggering:
				target_node = light_node
				break
