extends Node

export(PackedScene) var NEXT_STAGE
onready var triggerables = get_tree().get_nodes_in_group("triggable")

func _ready() -> void:
	GameData.key_count = triggerables.size()
	Events.connect("someone_entered_door", self, "on_someone_entered_door")

func on_someone_entered_door(someone) -> void:
	Events.emit_signal("game_clear")