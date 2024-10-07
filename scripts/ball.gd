extends RigidBody3D
class_name Ball

func on_kick(g_pos: Vector3, kick_power:float) -> void:
	var imp = (global_position - g_pos).normalized() * kick_power
	apply_central_impulse(imp)
	SoundEffectBus.play_unique(SoundEffectBus.kick)

func _physics_process(delta: float) -> void:
	#print(rotation_degrees)
	$Team1Area.global_rotation = Vector3(0,0,0)

func reset_posn() -> void:
	global_position = Vector3(0, 100, 0)
	linear_velocity = Vector3.ZERO
