tool

extends "res://src/TriggeredObjects/Conditions/BaseCondition.gd"

export(int) var degree = 90

func _process(delta: float) -> void:
	update()

func condition(parent, player) -> bool:
	var player_vel = player.velocity.normalized()
	
	if player_vel == Vector2.ZERO:
		player_vel = Vector2.LEFT if player.is_facing_left else Vector2.RIGHT
		
	var dir = deg_2_dir()
	
	var dot = dir.dot(player_vel)
	
	var deg = rad2deg(acos(dot))

	return deg < 20
	
var text: String = ""

func deg_2_dir() -> Vector2:
	var r = deg2rad(degree)
	return Vector2(cos(r), sin(r))

func _draw() -> void:
	var dir = deg_2_dir()
	var target =  dir * 50.0
	draw_line(Vector2.ZERO, target, Color.gold, 1.5)
	draw_circle(target, 5, Color.gold)