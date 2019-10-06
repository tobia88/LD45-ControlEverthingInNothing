extends Node

export(PackedScene) var NEXT_STAGE

func _ready() -> void:
	Events.connect("someone_entered_door", self, "on_someone_entered_door")

func on_someone_entered_door(someone) -> void:
	Events.emit_signal("game_clear")