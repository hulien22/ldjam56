extends RigidBody3D
class_name Player

@export var TIME_STUCK_IN_KICK: float = 5.0
@export var TIME_BETWEEN_JUMPS:float = 2.0
@export var move_speed:float = 1.0
@export var jump_power:float = 30
@export var kick_power:float = 100
@export var rot_speed: float = 0.1
@export var on_kicked_mult: float = 1.0
@export var reset_posn: Vector3 = Vector3.ZERO
@export var attack_angle_deg: float = 45
@export var is_team1: bool = true

@export var x_bound: float = 100
@export var z_bound: float = 75

@onready var nav:NavigationAgent3D = $NavigationAgent3D

var is_player_controlled:bool = false

var on_ground:bool = false;
var time_since_kicked:float
var time_since_last_jump: float

var ai_target_posn:Vector3
var closest_ball: Ball

func _ready() -> void:
	%TeamBottom.material_override = StandardMaterial3D.new()
	if is_team1:
		set_bottom_color(Color.DODGER_BLUE)
	else:
		set_bottom_color(Color.CRIMSON)
	
	time_since_kicked = TIME_STUCK_IN_KICK
	time_since_last_jump = TIME_BETWEEN_JUMPS

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
		%DizzyStars.hide()
	else:
		%DizzyStars.show()
	
	if (is_player_controlled):
		process_player_input()
	else:
		process_ai_movement()
		pass
	
	%TeamBottom.global_position = global_position
	%TeamBottom.global_position.y = 0.6
	%TeamBottom.global_rotation = Vector3.ZERO

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
			process_kick()
	apply_central_impulse(dir_to_move)


func process_ai_movement() -> void:
	if !can_move():
		return
	compute_target_posn()
	nav.target_position = ai_target_posn
	if (global_position - ai_target_posn).length_squared() < 10:
		return
	var next_point:Vector3 = nav.get_next_path_position()
	var dir:Vector3 = next_point - global_transform.origin
	dir.y = 0
	dir = dir.normalized() * move_speed
	
	#NavigationServer3D.agent_set_velocity(nav_agent_rid, linear_velocity)
	#nav.set_velocity(dir)
	dir_to_move = dir
	
	if %KickRay.is_colliding() && time_since_last_jump > TIME_BETWEEN_JUMPS:
		var obj = %KickRay.get_collider()
		if (obj is Ball):
			# only kick if towards other side
			if (is_team1 && global_position.x < obj.global_position.x) || (!is_team1 && global_position.x > obj.global_position.x):
				dir_to_move.y = jump_power
				process_kick()
		elif (obj is Player && obj.is_team1 != is_team1):
			dir_to_move.y = jump_power
			process_kick()

	apply_central_impulse(dir_to_move)

var dir_to_move: Vector3
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	# Keep in bounds
	if abs(global_position.x) > x_bound + 100:
		global_position = Vector3(0,100,0)
		linear_velocity = Vector3.ZERO
		return
	if abs(global_position.z) > z_bound + 100:
		global_position = Vector3(0,100,0)
		linear_velocity = Vector3.ZERO
		return
	if (global_position.y < -100):
		global_position.y = 100
		linear_velocity = Vector3.ZERO
		return

	if !can_move():
		swap_to_anim_if_not_started("RESET", 1.0)
		return
	
	#apply_torque_impulse(Vector3(0,1,0))
	#
	if (dir_to_move != Vector3.ZERO):
		#print(dir_to_move)
		look_follow(state, global_transform, global_position + dir_to_move)
		swap_to_anim_if_not_started("run", move_speed)
	else:
		swap_to_anim_if_not_started("bounce", 1.0)

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
	time_since_last_jump = 0.0
	if %KickRay.is_colliding():
		var obj = %KickRay.get_collider()
		if obj.has_method("on_kick"):
			obj.on_kick(global_position, kick_power)

func on_kick(g_pos: Vector3, k_power:float) -> void:
	#print(self, " Was kicked!")
	time_since_kicked = 0
	var imp = (global_position - g_pos + Vector3(0,1,0)).normalized() * k_power * on_kicked_mult
	apply_central_impulse(imp)

func swap_to_anim_if_not_started(anim: String, a_speed: float) -> void:
	if %AnimationPlayer.current_animation != anim:
		var t = %AnimationPlayer.get_current_animation_position()
		%AnimationPlayer.play(anim, -1, a_speed)
		%AnimationPlayer.seek(t)

func set_nav_reg(nr: NavigationRegion3D) -> void:
	nav.set_navigation_map(nr.get_navigation_map())

func set_bottom_color(c: Color) -> void:
	(%TeamBottom.material_override as StandardMaterial3D).albedo_color = c
	(%TeamBottom.material_override as StandardMaterial3D).emission_enabled = true
	(%TeamBottom.material_override as StandardMaterial3D).emission = c
	(%TeamBottom.material_override as StandardMaterial3D).emission_energy_multiplier = 1
	(%TeamBottom.material_override as StandardMaterial3D).albedo_color.a = 0.9
	(%TeamBottom.material_override as StandardMaterial3D).transparency = BaseMaterial3D.TRANSPARENCY_ALPHA 

func set_is_player(b: bool) -> void:
	is_player_controlled = b
	if is_player_controlled:
		set_bottom_color(Color.GOLD)
	elif is_team1:
		set_bottom_color(Color.DODGER_BLUE)
	else:
		set_bottom_color(Color.CRIMSON)

func set_closest_ball(b: Ball) -> void:
	closest_ball = b

func set_target_posn(p: Vector3) -> void:
	ai_target_posn = p
	ai_target_posn.y = 0

func compute_target_posn() -> void:
	# if no ball, return to reset posn?
	if closest_ball == null:
		#print(self, " no ball close")
		set_target_posn(reset_posn)
		return
	
	var my_posn: Vector2 = Vector2(global_position.x, global_position.z)
	var ball_posn: Vector2 = Vector2(closest_ball.global_position.x, closest_ball.global_position.z)
	var angle:float
	if (is_team1):
		angle = my_posn.angle_to_point(ball_posn)
	else:
		angle = ball_posn.angle_to_point(my_posn)
	
	# In the attack cone, so charge!!
	if (abs(angle) < deg_to_rad(attack_angle_deg)):
		#print(self, " charge!!")
		set_target_posn(closest_ball.global_position)
		return
	
	# behind the ball, but not in attack cone, so move towards the cone
	if (is_team1 && my_posn.x < ball_posn.x) || (!is_team1 && my_posn.x > ball_posn.x):
		var dir: Vector2 = Vector2.RIGHT * 100
		if my_posn.y > ball_posn.y:
			# below the ball
			dir = dir.rotated(-deg_to_rad(attack_angle_deg))
		else:
			# above the ball
			dir = dir.rotated(deg_to_rad(attack_angle_deg))
		if is_team1:
			# flip across y axis
			dir.x *= -1
		set_target_posn(global_position + Vector3(dir.x, 0, dir.y))
		#print(self, " move into attack cone")
		return
	
	# on wrong side of ball, need to get other side
	#print(self, " wrong side")
	var dir: Vector2 = Vector2.RIGHT * 100
	if is_team1:
		dir.x *= -1
	set_target_posn(global_position + Vector3(dir.x, 0, dir.y))
