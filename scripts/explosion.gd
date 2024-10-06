extends Node3D
class_name Explosion

func set_color(c : Color) -> void:
	(%GPUParticles3D.draw_pass_1.material as StandardMaterial3D).albedo_color = c
	(%GPUParticles3D.draw_pass_1.material as StandardMaterial3D).emission = c
	
	(%GPUParticles3D2.process_material as ParticleProcessMaterial).color = c
	

func _ready() -> void:
	%GPUParticles3D.emitting = true
	%GPUParticles3D2.emitting = true
	await get_tree().create_timer(1.0).timeout
	queue_free()
