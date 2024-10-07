extends Node3D

@onready var ball_scene = preload("res://scenes/ball.tscn")

var balls: Array[Ball] = []


func _on_timer_timeout() -> void:
	$Timer.wait_time = randf_range(2.5, 3.5)
	var b:Ball = ball_scene.instantiate()
	var v = Vector3.FORWARD * global_basis * 50
	v = v.rotated(Vector3(0,1,0), randf_range(-0.5,0.5))
	v.y = randf_range(50, 100)
	balls.push_back(b)
	add_child(b)
	b.global_position = global_position
	b.apply_central_impulse(v)
	
	if balls.size() > 5:
		var old_b: Ball = balls.pop_front()
		remove_child(old_b)
		old_b.queue_free()
	
