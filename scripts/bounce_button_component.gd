extends Node

@export var button: Control

func _ready() -> void:
	button.mouse_entered.connect(_on_mouse_entered)
	button.mouse_exited.connect(_on_mouse_exited)
	button.pivot_offset = button.size/2

func _on_mouse_entered() -> void:
	button.scale = Vector2(1.2,1.2)

func _on_mouse_exited() -> void:
	button.scale = Vector2(1,1)

#TODO sounds
