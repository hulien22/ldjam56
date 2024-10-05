extends Node3D


func _ready() -> void:
	load_players()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_text_indent"):
		players[cur_player].is_player_controlled = false
		cur_player = (cur_player + 1) % players.size()
		players[cur_player].is_player_controlled = true
	if Input.is_action_just_pressed("ui_text_backspace"):
		for p in players:
			p.set_target_posn(players[cur_player].global_position)

var players: Array[Node3D] = []
var cur_player: int = 0
func load_players():
	players = []
	for obj in $Players.get_children():
		players.push_back(obj)
		obj.is_player_controlled = false
		obj.set_nav_reg(%NavigationRegion3D)
	cur_player = 0
	players[cur_player].is_player_controlled = true
