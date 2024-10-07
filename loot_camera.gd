extends Camera3D

var looting = true

signal swap_player(card: Node3D)
signal flipped_card()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			on_click(event.position)

func _physics_process(delta: float) -> void:
	var pos = get_viewport().get_mouse_position()
	var result = get_world_3d().direct_space_state.intersect_ray(
		PhysicsRayQueryParameters3D.create(
			project_ray_origin(pos), 
			project_position(pos, 1000)))
	if result.has("collider"):
		if result["collider"].get_parent().get_child_count() > 0 and result["collider"].get_parent().get_child(0) is Card:
			result["collider"].get_parent().get_child(0).set_tilt(result["position"])
	
func on_click(pos: Vector2):
	var result = get_world_3d().direct_space_state.intersect_ray(
		PhysicsRayQueryParameters3D.create(
			project_ray_origin(pos), 
			project_position(pos, 1000)))
	if result.has("collider"):
		if result["collider"].get_parent().get_child_count() > 0 and result["collider"].get_parent().get_child(0) is Card:
			if looting:
				result["collider"].get_parent().get_child(0).flip_card()
				emit_signal("flipped_card")
			else:
				emit_signal("swap_player", result["collider"].get_parent())
	
func at_vending():
	looting = true

func at_sky():
	looting = false
