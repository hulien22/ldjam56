extends Node3D

@export var chars: Array[Character]
@export var char_option: PackedScene
var owned_chars: Dictionary
var a
var b
var c

var x
var y
var w
var z
var sel

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		#on_click(event.position)
		pass
			
func _ready() -> void:
	b = $LootBox/CenterCard
	c = $LootBox/RightRot/RightCard
	a = $LootBox/LeftRot/LeftCard
	
	w = $CharSelect/CardFlipHack
	x = $CharSelect/CardFlipHack2
	y = $CharSelect/CardFlipHack3
	z = $CharSelect/CardFlipHack4
	on_open_pack()
	

func on_open_pack():
	a.set_data(chars[0])
	b.set_data(chars[1])
	c.set_data(chars[2])
	owned_chars[chars[0]] = true
	owned_chars[chars[1]] = true
	owned_chars[chars[2]] = true
	$AnimationPlayer.play("goto_sky")
	$LootBox/AnimationPlayer.play("dispense")
	#replace_character()

func on_clear():
	pass

func goto_vending():
	$AnimationPlayer.play("goto_vend")

func goto_sky():
	$AnimationPlayer.play("goto_sky")
	
func replace_character(sele: Node3D):
	sel = sele
	var list = $CanvasLayer/ScrollContainer/VBoxContainer
	for c in list.get_children():
		list.remove_child(c)
		c.queue_free()
		
	for c in owned_chars:
		var op = char_option.instantiate()
		op.set_data(c)
		op.connect("selected_character", on_character_selected)
		list.add_child(op)
	$CanvasLayer/ScrollContainer.visible = true
	
	
func on_character_selected(data: Character):
	print("yooooo")
	print(data)
	sel.set_data(data)
	$CanvasLayer/ScrollContainer.visible = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
