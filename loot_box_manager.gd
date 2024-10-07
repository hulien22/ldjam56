extends Node3D

@export var basic_chars: Array[Character]
@export var lege_chars: Array[Character]

@export var char_option: PackedScene
var owned_chars: Dictionary
var a
var b
var c

var lel = 0
var x
var y
var w
var z
var sel

var lege_guar = true

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		#on_click(event.position)
		pass
			
func _ready() -> void:
	b = $LootBox/CenterCard
	c = $LootBox/RightRot/RightCard
	a = $LootBox/LeftRot/LeftCard
	
	w = $CharSelect/CardFlipHack
	w.set_big()
	x = $CharSelect/CardFlipHack2
	x.set_big()
	y = $CharSelect/CardFlipHack3
	y.set_big()
	z = $CharSelect/CardFlipHack4
	z.set_big()
	for q in basic_chars:
		if q.chance == 2:
			owned_chars[q] = true
			if lel == 0:
				x.set_data(q)
				Team.RM = q
			elif lel == 1:
				w.set_data(q)
				Team.GK = q
			elif lel == 2:
				y.set_data(q)
				Team.LM = q
			elif lel == 3:
				z.set_data(q)
				Team.ST = q
			lel += 1
	$AnimationPlayer.play("goto_sky")
	
func is_lege():
	if lege_guar:
		lege_guar = false
		return true
	else:
		return randi_range(0, 3) == 0
	
func random_pack():
	var lege_spot = [a, b, c].pick_random()
	if is_lege():
		var t = lege_chars.pick_random()
		lege_spot.set_data(t)
		owned_chars[t] = true
	else:
		var t = basic_chars.pick_random()
		lege_spot.set_data(t)
		owned_chars[t] = true
	if a != lege_spot:
		var t = basic_chars.pick_random()
		a.set_data(t)
		owned_chars[t] = true
	if b != lege_spot:
		var t = basic_chars.pick_random()
		b.set_data(t)
		owned_chars[t] = true
	if c != lege_spot:
		var t = basic_chars.pick_random()
		c.set_data(t)
		owned_chars[t] = true
	
func on_open_pack():
	random_pack()
	
	$LootBox/AnimationPlayer.play("dispense")
	#replace_character()

func on_clear():
	pass
	
func at_vend():
	on_open_pack()

func goto_vending():
	$AnimationPlayer.play("goto_vend")
	

func goto_sky():
	a.reset_card()
	b.reset_card()
	c.reset_card()
	$AnimationPlayer.play("goto_sky")
	$LootBox/AnimationPlayer.play("RESET")
	
func replace_character(sele: Node3D):
	sel = sele
	var list = $CanvasLayer/ScrollContainer/VBoxContainer
	for c in list.get_children():
		list.remove_child(c)
		c.queue_free()
		
	for c in owned_chars:
		if c == Team.GK or c == Team.LM or c == Team.RM or c == Team.ST:
			continue
		var op = char_option.instantiate()
		op.set_data(c)
		op.connect("selected_character", on_character_selected)
		list.add_child(op)
	$CanvasLayer/ScrollContainer.visible = true
	
	
func on_character_selected(data: Character):
	print(data)
	sel.reset_card()
	sel.set_data(data)
	$CanvasLayer/ScrollContainer.visible = false
	if sel == x:
		Team.RM = data
	elif sel == w:
		Team.GK = data
	elif sel == y:
		Team.LM = data
	elif sel == z:
		Team.ST = data
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
