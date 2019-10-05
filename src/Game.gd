extends Node2D

export(PackedScene) var start_scene

var current_scene

func _ready() -> void:
	Events.connect("game_clear", self, "on_game_clear")
	load_scene(start_scene)
	
func load_scene(packed_scene) -> void:
	if current_scene != null:
		current_scene.queue_free()
		
	current_scene = packed_scene.instance()
	add_child(current_scene)

func _process(delta: float) -> void:
	if Input.is_action_pressed("debug_activation"):
		"""
		Speed Up
		"""
		Engine.time_scale = 4 if Input.is_action_pressed("debug_speed_up") else 1
		
		"""
		Skip Level
		"""
		if Input.is_action_just_pressed("debug_skip_level"):
			Events.emit_signal("game_clear")
	
	$DebugLabel.text = "Time Scale: %s" % Engine.time_scale
			
	
func on_game_clear() -> void:
	if current_scene != null:
		remove_child(current_scene)
		
		if current_scene.NEXT_STAGE != null:
			load_scene(current_scene.NEXT_STAGE)
		