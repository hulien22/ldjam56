extends Node3D

@export var lobby_scene: PackedScene

func _ready() -> void:
	$Control/Button.grab_focus()

func on_play():
	get_tree().change_scene_to_packed(lobby_scene)
