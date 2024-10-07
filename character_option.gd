extends Control

signal selected_character(character: Character)

@export var text_b: CompressedTexture2D
@export var text_a: CompressedTexture2D
@export var text_s: CompressedTexture2D

var char: Character

func set_data(data: Character):
	match data.chance:
		2:
			$TextureButton.texture_normal = text_b
		1:
			$TextureButton.texture_normal = text_a
		_:
			$TextureButton.texture_normal = text_s
	char = data
	$TextureButton/Label.text = char.name

func on_pressed():
	emit_signal("selected_character", char)
	
