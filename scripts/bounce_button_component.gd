extends Node

@export var button: Button
@export var do_rotate:bool = true

func _ready() -> void:
	button.mouse_entered.connect(_on_mouse_entered)
	button.mouse_exited.connect(_on_mouse_exited)
	button.pivot_offset = button.size/2
	if do_rotate:
		var tween: Tween = create_tween().set_loops().set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(button, "rotation", -0.1, 0.5)
		tween.tween_property(button, "rotation", 0.1, 1)
		tween.tween_property(button, "rotation", 0, 0.5)

func _on_mouse_entered() -> void:
	if !button.disabled:
		button.scale = Vector2(1.2,1.2)
		SoundEffectBus.play_kick()

func _on_mouse_exited() -> void:
	button.scale = Vector2(1,1)

#TODO sounds
