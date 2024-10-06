extends Node3D

signal goal(body:Node3D)

# Balls are on layer 2
func _on_area_3d_body_entered(body: Node3D) -> void:
	print("GOAL ENTERED ", body)
	goal.emit(body)
