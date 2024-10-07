extends Node3D

const MIN_BALL_DISTANCE:float = 10000000000
@onready var explosion_scene = preload("res://scenes/explosion.tscn")
@onready var ball_scene = preload("res://scenes/ball.tscn")

enum GameMode {INTRO, GAME, AFTERGAME}

var game_mode:GameMode = GameMode.INTRO
var team1_score: int = 0
var team2_score: int = 0

func _ready() -> void:
	load_balls()
	load_players()
	play_intro()
	%ClockLabel.text = str(clock_time)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_text_indent"):
		players[cur_player].set_is_player(false)
		while true:
			cur_player = (cur_player + 1) % players.size()
			if players[cur_player].is_team1:
				break
		players[cur_player].set_is_player(true)
	if Input.is_action_just_pressed("ui_text_backspace"):
		for p in players:
			p.set_target_posn(players[cur_player].global_position)
	
	for p in players:
		var min_distance_sq:float = MIN_BALL_DISTANCE
		var min_ball:Ball = null
		for b in balls:
			if !p.is_in_ai_region(b.global_position):
				continue
			# TODO consider y direction?
			var dist_sq = p.global_position.distance_squared_to(b.global_position)
			if dist_sq < min_distance_sq:
				min_ball = b
				min_distance_sq = dist_sq
		p.set_closest_ball(min_ball)
		

var balls: Array[Ball] = []
func load_balls():
	balls = []  
	#for obj in %Balls.get_children():
		#balls.push_back(obj)
	var num_balls:int = 3 # assumes odd num
	for i in num_balls:
		var b:Ball = ball_scene.instantiate()
		balls.push_back(b)
		%Balls.add_child(b)
		b.global_position = Vector3(0, 40, (i - num_balls/2) * 40)
		b.freeze = true

var players: Array[Player] = []
var cur_player: int = 0
func load_players():
	players = []  
	for obj in %Players.get_children():
		players.push_back(obj)
		obj.set_is_player(false)
		obj.set_nav_reg(%NavigationRegion3D)
		obj.enable(false)
		if obj.is_team1:
			obj.global_rotation.y = 0
		else:
			obj.global_rotation.y = PI
		match players.size():
			1:
				obj.set_ai_play_region($SpawnPositions/Team1/Keeper, $AiRegions/Team1/Keeper)
				obj.global_position = $SpawnPositions/Team1/Keeper.global_position
			2:
				obj.set_ai_play_region($SpawnPositions/Team1/TopMid, $AiRegions/Team1/TopMid)
				obj.global_position = $SpawnPositions/Team1/TopMid.global_position
			3:
				obj.set_ai_play_region($SpawnPositions/Team1/BotMid, $AiRegions/Team1/BotMid)
				obj.global_position = $SpawnPositions/Team1/BotMid.global_position
			4:
				obj.set_ai_play_region($SpawnPositions/Team1/Striker, $AiRegions/Team1/Striker)
				obj.global_position = $SpawnPositions/Team1/Striker.global_position
			5:
				obj.set_ai_play_region($SpawnPositions/Team2/Keeper, $AiRegions/Team2/Keeper)
				obj.global_position = $SpawnPositions/Team2/Keeper.global_position
			6:
				obj.set_ai_play_region($SpawnPositions/Team2/TopMid, $AiRegions/Team2/TopMid)
				obj.global_position = $SpawnPositions/Team2/TopMid.global_position
			7:
				obj.set_ai_play_region($SpawnPositions/Team2/BotMid, $AiRegions/Team2/BotMid)
				obj.global_position = $SpawnPositions/Team2/BotMid.global_position
			_:
				obj.set_ai_play_region($SpawnPositions/Team2/Striker, $AiRegions/Team2/Striker)
				obj.global_position = $SpawnPositions/Team2/Striker.global_position
			
	cur_player = 0
	#players[cur_player].set_is_player(true)

func show_scores():
	%Team1Score.text = str(team1_score)
	%Team2Score.text = str(team2_score)

func _on_goal_goal(body: Node3D, team1_net: bool) -> void:
	if body.has_method("reset_posn"):
		var explosion = explosion_scene.instantiate()
		explosion.set_spawn_posn(body.get_global_position())
		if team1_net:
			team2_score += 1
			explosion.set_color(Color.CRIMSON)
		else:
			team1_score += 1
			explosion.set_color(Color.CORNFLOWER_BLUE)
		add_child(explosion)
		body.reset_posn()
		show_scores()
	
func play_intro() -> void:
	%OpeningCam.current = true
	var tween:Tween = create_tween()
	tween.tween_property(%CamHolder, "rotation", Vector3(0, 0, 0), 0.1)
	tween.tween_property(%CamHolder, "rotation", Vector3(0, 2*PI, 0), 5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(%OpeningCam, "position", Vector3(0, 110, 70), 5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(%OpeningCam, "current", false, 0.001)
	tween.parallel().tween_property(%MainGameCamera, "current", true, 0.001)
	tween.tween_property(%Countdown, "text", "3", 0.001)
	tween.parallel().tween_callback(SoundEffectBus.play_countdown_beep)
	tween.tween_property(%Countdown, "modulate", Color(255,255,255,1), 0.001)
	tween.tween_property(%Countdown, "modulate", Color(255,255,255,0), 0.998).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(%Countdown, "text", "2", 0.001)
	tween.parallel().tween_callback(SoundEffectBus.play_countdown_beep)
	tween.tween_property(%Countdown, "modulate", Color(255,255,255,1), 0.001)
	tween.tween_property(%Countdown, "modulate", Color(255,255,255,0), 0.998).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(%Countdown, "text", "1", 0.001)
	tween.parallel().tween_callback(SoundEffectBus.play_countdown_beep)
	tween.tween_property(%Countdown, "modulate", Color(255,255,255,1), 0.001)
	tween.tween_property(%Countdown, "modulate", Color(255,255,255,0), 0.998).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_callback(start_game)
	tween.tween_property(%Countdown, "text", "GO!", 0.001)
	tween.parallel().tween_callback(SoundEffectBus.play_final_beep)
	tween.tween_property(%Countdown, "modulate", Color(255,255,255,1), 0.001)
	tween.tween_property(%Countdown, "modulate", Color(255,255,255,0), 0.998).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
func start_game():
	game_mode = GameMode.GAME
	for p in players:
		p.enable(true)
	# TODO start spawning in balls
	for b in balls:
		b.freeze = false
	$Timer.start()

func _process(delta: float) -> void:
	if game_mode == GameMode.INTRO && %OpeningCam.current:
		%OpeningCam.look_at(Vector3(0,4,0))

func go_to_menu():
	get_tree().change_scene_to_file("res://scenes/mainmenu.tscn")

var clock_time: int = 60
func _on_timer_timeout() -> void:
	clock_time -= 1
	%ClockLabel.text = str(clock_time)
	if (clock_time == 0):
		stop_game()

func stop_game():
	game_mode = GameMode.AFTERGAME
	$Timer.stop()
	for p in players:
		p.enable(false)
	for b in balls:
		b.freeze = true
	
