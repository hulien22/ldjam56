extends Player

func process_kick() -> void:
	super.process_kick()
	$TongueMesh.show()
	await get_tree().create_timer(0.2).timeout
	$TongueMesh.hide()
