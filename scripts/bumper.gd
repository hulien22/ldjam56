extends Node3D

@export var gravity_dir:Vector3 = Vector3(1,1,1)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area3D.gravity_direction = gravity_dir

func _on_area_3d_body_entered(body: Node3D) -> void:
	#if body is Player || body is Ball:
		#print("Hit")
		#$Model.scale = Vector3(5,5,5)
		#var tween:Tween = create_tween()
		#tween.tween_property($Model, "scale", Vector3(1,1,1), 1)
	pass

const SOUND_TIMEOUT:float = 0.2
var time_since_boing:float = SOUND_TIMEOUT
func _physics_process(delta: float) -> void:
	time_since_boing += delta

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is Player || body is Ball:
		#print("Hit")
		$Model.scale = Vector3(2,2,2)
		var tween:Tween = create_tween()
		tween.tween_property($Model, "scale", Vector3(1,1,1), 1)
		
		if time_since_boing > SOUND_TIMEOUT:
			time_since_boing = 0
			SoundEffectBus.play_unique(SoundEffectBus.boing, 10)
