extends Control

signal selected_character(character: Character)

var char: Character

func set_data(data: Character):
	char = data
	$TextureButton/Label.text = char.name

func on_pressed():
	emit_signal("selected_character", char)
	
