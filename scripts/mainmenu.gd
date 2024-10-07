extends Node3D

@export var lobby_scene: PackedScene

@onready var explosion_scene = preload("res://scenes/explosion.tscn")

func _ready() -> void:
	$Control/Button.grab_focus()
	
	#load an explosion
	var explosion = explosion_scene.instantiate()
	explosion.play_sound = false
	explosion.set_spawn_posn(Vector3(0,-1000,0))
	add_child(explosion)

func on_play():
	get_tree().change_scene_to_packed(lobby_scene)
