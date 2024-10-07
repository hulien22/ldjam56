extends Node2D

@export var game_scene: PackedScene

func _on_start_match_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)

func _ready() -> void:
	Globals.did_gameplay_tutorial = true
