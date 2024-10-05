extends RigidBody3D
class_name Player

@export var TIME_STUCK_IN_KICK: float = 5.0
@export var TIME_BETWEEN_JUMPS:float = 2.0
@export var move_speed:float = 1.0
@export var jump_power:float = 30
@export var kick_power:float = 100

var is_player_controlled:bool = false

var on_ground:bool = false;
var time_since_kicked:float = TIME_STUCK_IN_KICK
var time_since_last_jump: float = TIME_BETWEEN_JUMPS

func can_move() -> bool:
	return on_ground && time_since_kicked >= TIME_STUCK_IN_KICK

func _physics_process(delta: float) -> void:
	dir_to_move = Vector3.ZERO
	time_since_kicked += delta
	if (%IsOnGround.is_colliding()):
		on_ground = true
		time_since_last_jump += delta
	else:
		on_ground = false
	
	if can_move():
		%MeshInstance3D.hide()
	else:
		%MeshInstance3D.show()
	
	if (is_player_controlled):
		process_player_input()

func process_player_input() -> void:
	if !can_move():
		return
	if Input.is_action_pressed("ui_left"):
		dir_to_move.x -= 1
	if Input.is_action_pressed("ui_right"):
		dir_to_move.x += 1
	if Input.is_action_pressed("ui_down"):
		dir_to_move.z += 1
	if Input.is_action_pressed("ui_up"):
		dir_to_move.z -= 1
		
	dir_to_move = dir_to_move.normalized() * move_speed
	
	# process jump afterwards
	if Input.is_action_just_pressed("ui_accept"):
		if time_since_last_jump > TIME_BETWEEN_JUMPS:
			dir_to_move.y = jump_power
			time_since_last_jump = 0.0
			process_kick()
	apply_central_impulse(dir_to_move)
	

var dir_to_move: Vector3
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if !can_move():
		return
	
	#apply_torque_impulse(Vector3(0,1,0))
	#
	if (dir_to_move != Vector3.ZERO):
		print(dir_to_move)
		look_follow(state, global_transform, global_position + dir_to_move)

var rot_speed: float = 0.1
func look_follow(state: PhysicsDirectBodyState3D, current_transform: Transform3D, target_position: Vector3) -> void:
	var forward_local_axis: Vector3 = Vector3(1, 0, 0)
	var forward_dir: Vector3 = (current_transform.basis * forward_local_axis).normalized()
	var target_dir: Vector3 = (target_position - current_transform.origin).normalized()
	var local_speed: float = clampf(rot_speed, 0, acos(forward_dir.dot(target_dir)))
	if abs(forward_dir.dot(target_dir)) > 1e-4:
		var new_av = local_speed * forward_dir.cross(target_dir) / state.step
		#state.angular_velocity = new_av
		state.angular_velocity.y = new_av.y

func process_kick() -> void:
	if %KickRay.is_colliding():
		var obj = %KickRay.get_collider()
		if obj.has_method("on_kick"):
			obj.on_kick(global_position, kick_power)

func on_kick(g_pos: Vector3, k_power:float) -> void:
	print(self, " Was kicked!")
	time_since_kicked = 0
	var imp = (global_position - g_pos + Vector3(0,1,0)).normalized() * k_power
	apply_central_impulse(imp)
