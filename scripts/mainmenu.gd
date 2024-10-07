extends Node3D

@export var lobby_scene: PackedScene

func _ready() -> void:
	$Control/Button.grab_focus()

func _on_label_2_mouse_entered() -> void:
	$Control/Button.scale = Vector2(1.2,1.2)

func _on_label_2_mouse_exited() -> void:
	$Control/Button.scale = Vector2(1,1)

func on_play():
	get_tree().change_scene_to_packed(lobby_scene)
