extends Node3D

@export var basic_chars: Array[Character]
@export var lege_chars: Array[Character]

@export var char_option: PackedScene
@export var game_scene: PackedScene
@export var game_tutorial_scene: PackedScene
#var owned_chars: Dictionary
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

enum Location {ROSTER, STORE}
var loc:Location = Location.ROSTER

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
	if Team.GK == null:
		for q in basic_chars:
			if q.chance == 2:
				if lel < 4:
					Team.owned_chars[q] = true
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
				#elif lel == 4: #setting the first enemy team :)
					#Team.Enemy_GK = q
				#elif lel == 5:
					#Team.Enemy_LM = q
				#elif lel == 6:
					#Team.Enemy_RM = q
				#elif lel == 7:
					#Team.Enemy_ST = q
				lel += 1
	else:
		x.set_data(Team.RM)
		w.set_data(Team.GK)
		y.set_data(Team.LM)
		z.set_data(Team.ST)
		
	# set random enemy team, will get overwritten
	Team.Enemy_GK = lege_chars.pick_random()
	Team.Enemy_LM = lege_chars.pick_random()
	Team.Enemy_RM = lege_chars.pick_random()
	Team.Enemy_ST = lege_chars.pick_random()
	
	$AnimationPlayer.play("goto_sky", -1, 1.0, true)
	
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
		Team.owned_chars[t] = true
	else:
		var t = basic_chars.pick_random()
		lege_spot.set_data(t)
		Team.owned_chars[t] = true
	if a != lege_spot:
		var t = basic_chars.pick_random()
		a.set_data(t)
		Team.owned_chars[t] = true
	if b != lege_spot:
		var t = basic_chars.pick_random()
		b.set_data(t)
		Team.owned_chars[t] = true
	if c != lege_spot:
		var t = basic_chars.pick_random()
		c.set_data(t)
		Team.owned_chars[t] = true
	
func on_open_pack():
	%BuyPack.hide()
	%MoneyLbl.hide()
	%GoToRoster.hide()
	%TutorialPanel.hide()
	Globals.bought_a_pack = true
	random_pack()
	
	$LootBox/AnimationPlayer.play("dispense")
	#replace_character()

func on_play():
	if Globals.did_gameplay_tutorial:
		get_tree().change_scene_to_packed(game_scene)
	else:
		get_tree().change_scene_to_packed(game_tutorial_scene)

func on_clear():
	pass
	
func at_vend():
	#on_open_pack()
	a.reset_card()
	b.reset_card()
	c.reset_card()
	$LootBox/CenterCard.global_position.y = 0.64
	$LootBox/RightRot.global_position.y = 0.64
	$LootBox/LeftRot.global_position.y = 0.64
	$LootBox/AnimationPlayer.play("dispense", -1, -1)
	
	%BuyPack.disabled = Globals.money < 3
	%BuyPack.show()
	%MoneyLbl.text = "$" + str(Globals.money)
	%MoneyLbl.show()
	%GoToRoster.show()
	if !Globals.bought_a_pack:
		%GoToRoster.hide()
		%TutorialPanel.show()
		%TutorialPanel/text.text = "Purchase a pack to get new players!"
	elif !Globals.swapped_a_player:
		%TutorialPanel.show()
		%TutorialPanel/text.text = "Now lets head back and update our roster"
		

func at_sky():
	%Roster.show()
	if Team.owned_chars.size() > 4:
		%Roster/text2.show()
	
	if !Globals.did_roster_tutorial1:
		Globals.did_roster_tutorial1 = true
		%TutorialPanel.show()
		%TutorialPanel/text.text = "This is your current team\n\nThey're not very good...\n\nGo to the store to get some new players"
		%StartMatch.hide()
	elif !Globals.swapped_a_player:
		%StartMatch.hide()
		%TutorialPanel.show()
		%TutorialPanel/text.text = "Swap out one of our players"
	else:
		%StartMatch.show()

func goto_vending():
	if (loc != Location.STORE):
		loc = Location.STORE
		$LootBox/AnimationPlayer.play("dispense", -1, -1)
		$AnimationPlayer.play("goto_vend")
		$CanvasLayer/ScrollContainer.visible = false
		$CanvasLayer/Panel.visible = false
		
		%Roster.hide()
		%TutorialPanel.hide()

func goto_sky():
	if loc != Location.ROSTER:
		loc = Location.ROSTER
		$AnimationPlayer.play("goto_sky")
		%BuyPack.hide()
		%MoneyLbl.hide()
		%GoToRoster.hide()
		%TutorialPanel.hide()
	
var is_selecting:bool = false
func replace_character(sele: Node3D):
	if is_selecting || Team.owned_chars.size() <= 4:
		return
	SoundEffectBus.play_cardmany()
	is_selecting = true
	sel = sele
	var list = $CanvasLayer/ScrollContainer/VBoxContainer
	for c in list.get_children():
		list.remove_child(c)
		c.queue_free()
		
	for c in Team.owned_chars:
		if c == Team.GK or c == Team.LM or c == Team.RM or c == Team.ST:
			continue
		var op = char_option.instantiate()
		op.set_data(c)
		op.connect("selected_character", on_character_selected)
		list.add_child(op)
	$CanvasLayer/ScrollContainer.visible = true
	$CanvasLayer/Panel.visible = true
	%Roster.hide()
	
	
func on_character_selected(data: Character):
	#print(data)
	sel.reset_card()
	sel.set_data(data)
	if sel == x:
		Team.RM = data
	elif sel == w:
		Team.GK = data
	elif sel == y:
		Team.LM = data
	elif sel == z:
		Team.ST = data
	%Roster.show()
	$CanvasLayer/ScrollContainer.visible = false
	$CanvasLayer/Panel.visible = false
	is_selecting = false
	SoundEffectBus.play_cardflip()
	Globals.swapped_a_player = true
	%StartMatch.show()
	%TutorialPanel.hide()

func _on_stop_select_pressed() -> void:
	%Roster.show()
	$CanvasLayer/ScrollContainer.visible = false
	$CanvasLayer/Panel.visible = false
	is_selecting = false

func _on_buy_pack_pressed() -> void:
	Globals.money -= 3
	SoundEffectBus.play_cash()
	on_open_pack()


func _on_add_to_roster_pressed() -> void:
	%AddToRoster.hide()
	SoundEffectBus.play_cardmany()
	var tween:Tween = create_tween()
	tween.tween_property($LootBox/CenterCard, "global_position", Vector3($LootBox/CenterCard.global_position.x, -2, $LootBox/CenterCard.global_position.z), 0.5)
	tween.parallel().tween_property($LootBox/RightRot, "global_position",  Vector3($LootBox/RightRot.global_position.x, -2, $LootBox/RightRot.global_position.z), 0.5)
	tween.parallel().tween_property($LootBox/LeftRot, "global_position",  Vector3($LootBox/LeftRot.global_position.x, -2, $LootBox/LeftRot.global_position.z), 0.5)
	tween.tween_callback(at_vend)


func _on_flipped_pack_card() -> void:
	# Check if all cards are flipped
	var cards_to_check = []
	cards_to_check.push_back(a)
	cards_to_check.push_back(b)
	cards_to_check.push_back(c)
	
	for card in cards_to_check:
		if card.internal_card.rot != 0:
			return
	# all cards are flipped!
	%AddToRoster.show()
