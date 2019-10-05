extends Node

onready var triggerables = get_tree().get_nodes_in_group("triggable")

func _ready() -> void:
	GameData.key_count = triggerables.size()