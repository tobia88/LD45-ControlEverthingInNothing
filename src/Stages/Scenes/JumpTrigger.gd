tool

extends "res://src/TriggeredObjects/SomeoneTriggableObject.gd"

export(int) var JUMP_DEGREE: int = 90
export(int) var JUMP_FORCE: int = 300
export(bool) var CHECK_DEG: bool = false

var vel = Vector2.ZERO
var wait_for_light_off = false

func _process(delta: float) -> void:
	._process(delta)
	$DebugLabel.text = "Detection=%s"%detection
	update()

func detect_condition(someone) -> bool:
	if not .detect_condition(someone):
		return false
	"""
	var direct_space = get_world_2d().direct_space_state
	var result = direct_space.intersect_ray(global_position, someone.global_position, [self])
	if result:
		print_debug(name + ", " + result["collider"].name)
		return false
	"""
	
	var facing = (global_position - someone.global_position).normalized()
	
	if CHECK_DEG:
		var vd = Vector2.LEFT if someone.is_facing_left else Vector2.RIGHT
		
		var dot = facing.dot(vd)
		var deg = rad2deg(acos(dot))
		
		if abs(deg) > 50:
			return false
	
	detection = true
	
	var dir = deg_to_dir()
	
	detection = sign(facing.x) == sign(dir.x)
	return detection
	
func do_right_thing(someone) -> void:
	.do_right_thing(someone)
	someone.jump(deg_to_dir() * JUMP_FORCE)

func check_conditions(player) -> bool:
	if not .check_conditions(player):
		return false
		
	if not player.is_grounding or not is_triggering:
		return false
	
	var player_vel = player.velocity.normalized()
	
	if player_vel == Vector2.ZERO:
		player_vel = Vector2.LEFT if player.is_facing_left else Vector2.RIGHT
		
	var dir = deg_to_dir()
	
	var dot = dir.dot(player_vel)
	
	var deg = rad2deg(acos(dot))

	return deg < 85

func deg_to_dir() -> Vector2:
	var rad = deg2rad(JUMP_DEGREE)
	return Vector2(cos(rad), sin(rad))

func _draw() -> void:
	var nb_points = 40
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