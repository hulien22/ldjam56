extends Node3D
class_name Explosion

var play_sound:bool = true

func set_color(c : Color) -> void:
	(%GPUParticles3D.draw_pass_1.material as StandardMaterial3D).albedo_color = c
	(%GPUParticles3D.draw_pass_1.material as StandardMaterial3D).emission = c
	
	(%GPUParticles3D2.process_material as ParticleProcessMaterial).color = c

var spawn_posn:  Vector3
func set_spawn_posn(p: Vector3) -> void:
	spawn_posn = p

func _ready() -> void:
	global_position = spawn_posn
	%GPUParticles3D.emitting = true
	%GPUParticles3D2.emitting = true
	if play_sound:
		SoundEffectBus.play_unique(SoundEffectBus.airhorn)
	await get_tree().create_timer(1.0).timeout
	queue_free()
