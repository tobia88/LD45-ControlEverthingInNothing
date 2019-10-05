tool

extends Area2D

var is_triggering: bool = false setget set_is_triggered
export(int) var JUMP_DEGREE = 90
export(int) var JUMP_FORCE = 300

var vel = Vector2.ZERO

func _process(delta: float) -> void:
	var result = false

	var areas = self.get_overlapping_areas()

	for area_node in areas:
		if area_node.is_in_group("light"):
			result = true
			break

	set_is_triggered(result)
	
	update()

func set_is_triggered(value) -> void:
	if value == is_triggering:
		return

	is_triggering = value

func _on_JumpTrigger_body_entered(body: PhysicsBody2D) -> void:
	if body == null:
		return

	if body.is_in_group("someone"):
		body.jump(deg_to_dir() * JUMP_FORCE)

func deg_to_dir() -> Vector2:
	var rad = deg2rad(JUMP_DEGREE)
	return Vector2(cos(rad), sin(rad))

func _draw() -> void:
	var nb_points = 80
	var points_arc = PoolVector2Array()
	
	var velocity = deg_to_dir() * JUMP_FORCE
	var pos = Vector2.ZERO
	
	var delta = 0.01
	
	for i in range(nb_points):
		points_arc.push_back(pos)
		pos += velocity * delta
		velocity.y += GameData.GRAVITY * 0.8
	
	for index_point in range(nb_points-1):
		draw_line(points_arc[index_point], points_arc[index_point+1], Color.yellowgreen)