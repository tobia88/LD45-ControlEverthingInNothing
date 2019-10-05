extends KinematicBody2D

export(float) var MOVE_SPD = 100

var target_node

func _ready() -> void:
	Events.connect("on_start_trigger", self, "on_trigger_started")
	Events.connect("on_stop_trigger", self, "on_trigger_stopped")

func _process(delta: float) -> void:
	if target_node == null:
		return
		
	var dist_x = target_node.global_position.x - global_position.x
	if abs(dist_x) >= 0.1:
		move_and_slide(Vector2(sign(dist_x),0) * MOVE_SPD)

func on_trigger_started(node) -> void:
	if target_node == null or target_node != null and node.priority > target_node.priority:
		target_node = node

func on_trigger_stopped(node) -> void:
	if target_node == node:
		target_node = null
		