class_name Card
extends MeshInstance3D
			
var rot = PI
var tilt_target = Vector2.ZERO

func _physics_process(delta: float) -> void:
	get_parent().transform.basis = get_parent().transform.basis.slerp(Basis(Vector3(0,1,0), rot), 0.1)
	var ty = -tilt_target.y
	if rot != 0:
		ty = -ty
	transform.basis = transform.basis.slerp(Basis(Vector3(1,0,0), ty) * Basis(Vector3(0,1,0), tilt_target.x), 0.05)
	tilt_target = Vector2.ZERO
	
func flip_card():
	if rot == 0:
		rot = PI
	else:
		rot = 0

func set_tilt(pos: Vector3):
	tilt_target = pos - global_position
