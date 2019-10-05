extends Node

onready var triggerables = get_tree().get_nodes_in_group("triggable")

func _ready() -> void:
	GameData.key_count = triggerables.size()
	Events.connect("someone_entered_door", self, "on_someone_entered_door")

func on_someone_entered_door(someone) -> void:
	print_debug("Game Clear")