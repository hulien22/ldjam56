extends MeshInstance3D

@export var subscene: Node3D

func _process(delta: float) -> void:
	subscene.global_position = global_position
	subscene.global_rotation = global_rotation
