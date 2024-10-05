extends RigidBody3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta: float) -> void:
	#var dir:Vector2 = Vector2.ZERO
	#
	#if Input.is_action_pressed("ui_left"):
		#dir.x -= 1
	#if Input.is_action_pressed("ui_right"):
		#dir.x += 1
	#if Input.is_action_pressed("ui_down"):
		#dir.y += 1
	#if Input.is_action_pressed("ui_up"):
		#dir.y -= 1
	#
	#apply_central_impulse(Vector3(dir.x, 0, dir.y))

#func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
func _physics_process(delta: float) -> void:
	var dir:Vector2 = Vector2.ZERO
	
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	if Input.is_action_pressed("ui_down"):
		dir.y += 1
	if Input.is_action_pressed("ui_up"):
		dir.y -= 1
	dir = dir.normalized() * 2
	
	apply_central_impulse(Vector3(dir.x, 0, dir.y))
	
