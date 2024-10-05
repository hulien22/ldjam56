extends RigidBody3D

var can_control:bool = false;
const TIME_BETWEEN_JUMPS:float = 2.0
var time_since_last_jump: float = TIME_BETWEEN_JUMPS
func _physics_process(delta: float) -> void:
	if ($IsOnGround.is_colliding()):
		can_control = true
		time_since_last_jump += delta
		$MeshInstance3D.hide()
	else:
		can_control = false
		$MeshInstance3D.show()

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if !can_control:
		return
	var dir:Vector2 = Vector2.ZERO
	var jump:float = 0.0
	
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	if Input.is_action_pressed("ui_down"):
		dir.y += 1
	if Input.is_action_pressed("ui_up"):
		dir.y -= 1
	if Input.is_action_pressed("ui_accept"):
		print(time_since_last_jump)
		if time_since_last_jump > TIME_BETWEEN_JUMPS:
			jump = 30
			time_since_last_jump = 0.0
	
	dir = dir.normalized() * 2
	
	apply_central_impulse(Vector3(dir.x, jump, dir.y))
	#apply_torque_impulse(Vector3(0,1,0))
	#
	if (dir != Vector2.ZERO):
		look_follow(state, global_transform, global_position + Vector3(dir.x, 0, dir.y))

var rot_speed: float = 0.1
func look_follow(state: PhysicsDirectBodyState3D, current_transform: Transform3D, target_position: Vector3) -> void:
	var forward_local_axis: Vector3 = Vector3(1, 0, 0)
	var forward_dir: Vector3 = (current_transform.basis * forward_local_axis).normalized()
	var target_dir: Vector3 = (target_position - current_transform.origin).normalized()
	var local_speed: float = clampf(rot_speed, 0, acos(forward_dir.dot(target_dir)))
	if forward_dir.dot(target_dir) > 1e-4:
		var new_av = local_speed * forward_dir.cross(target_dir) / state.step
		#state.angular_velocity = new_av
		state.angular_velocity.y = new_av.y

func rotate_towards(state: PhysicsDirectBodyState3D, current_transform: Transform3D, target_dir: Vector3) -> void:
	var forward_local_axis: Vector3 = Vector3(1, 0, 0)
	var forward_dir: Vector3 = (current_transform.basis * forward_local_axis).normalized()
	#state.apply_torque_impulse()
