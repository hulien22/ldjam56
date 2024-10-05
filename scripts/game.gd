extends Node3D

const MIN_BALL_DISTANCE:float = 1000000

func _ready() -> void:
	load_balls()
	load_players()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_text_indent"):
		players[cur_player].is_player_controlled = false
		cur_player = (cur_player + 1) % players.size()
		players[cur_player].is_player_controlled = true
	if Input.is_action_just_pressed("ui_text_backspace"):
		for p in players:
			p.set_target_posn(players[cur_player].global_position)
	
	for p in players:
		var min_distance_sq:float = MIN_BALL_DISTANCE
		var min_ball:Ball = null
		for b in balls:
			# TODO consider y direction?
			var dist_sq = p.global_position.distance_squared_to(b.global_position)
			if dist_sq < min_distance_sq:
				min_ball = b
				min_distance_sq = dist_sq
		p.set_closest_ball(min_ball)
		

var balls: Array[Ball] = []
func load_balls():
	balls = []  
	for obj in $Balls.get_children():
		balls.push_back(obj)

var players: Array[Player] = []
var cur_player: int = 0
func load_players():
	players = []  
	for obj in $Players.get_children():
		players.push_back(obj)
		obj.is_player_controlled = false
		obj.set_nav_reg(%NavigationRegion3D)
	cur_player = 0
	players[cur_player].is_player_controlled = true
