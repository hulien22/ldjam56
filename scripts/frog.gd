extends Player

func process_jump_kick() -> void:
	super.process_jump_kick()
	%TongueMesh.show()
	await get_tree().create_timer(0.2).timeout
	%TongueMesh.hide()

func _ready():
	super()
	match rarity:
		0:
			%KickRay.target_position.x += 20
			%KickRay2.target_position.x += 20
			%KickRay3.target_position.x += 20
			%KickRay4.target_position.x += 20
			%KickRay5.target_position.x += 20
			%TongueMesh.mesh.height = 50
			%TongueMesh.position.x = 24
		1:
			%KickRay.target_position.x += 10
			%KickRay2.target_position.x += 10
			%KickRay3.target_position.x += 10
			%KickRay4.target_position.x += 10
			%KickRay5.target_position.x += 10
			%TongueMesh.mesh.height = 40
			%TongueMesh.position.x = 19
		_:
			pass
