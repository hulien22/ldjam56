extends RigidBody3D

func on_kick(g_pos: Vector3, kick_power:float) -> void:
	var imp = (global_position - g_pos).normalized() * kick_power
	apply_central_impulse(imp)

func _physics_process(delta: float) -> void:
	#print(rotation_degrees)
	$Team1Area.global_rotation = Vector3(0,0,0)
