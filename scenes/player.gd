extends RigidBody3D

var on_ground:bool = false;
const TIME_STUCK_IN_KICK:float = 5.0
var time_since_kicked:float = TIME_STUCK_IN_KICK
const TIME_BETWEEN_JUMPS:float = 2.0
var time_since_last_jump: float = TIME_BETWEEN_JUMPS

func can_move() -> bool:
	return on_ground && time_since_kicked >= TIME_STUCK_IN_KICK

func _physics_process(delta: float) -> void:
	time_since_kicked += delta
	if ($IsOnGround.is_colliding()):
		on_ground = true
		time_since_last_jump += delta
	else:
		on_ground = false
	
	if can_move():
		$MeshInstance3D.hide()
	else:
		$MeshInstance3D.show()
		

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if !can_move():
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
		if time_since_last_jump > TIME_BETWEEN_JUMPS:
			jump = 30
			time_since_last_jump = 0.0
			process_kick()
	
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

func process_kick() -> void:
	if $KickRay.is_colliding():
		var obj = $KickRay.get_collider()
		if obj.has_method("on_kick"):
			var kick_power:float = 100
			obj.on_kick(global_position, kick_power)

func on_kick(g_pos: Vector3, kick_power:float) -> void:
	print(self, " Was kicked!")
	time_since_kicked = 0
	var imp = (global_position - g_pos).normalized() * kick_power
	apply_central_impulse(imp)
