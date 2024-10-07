extends Node

var money:int = 30

var match_num: int = 0
var team_num: int = 0
@export var teams: Array[Character]
@export var team_names: Array[String]
@export var match_length: Array[int]

func load_enemy_team():
	Team.Enemy_GK = teams[team_num * 4]
	Team.Enemy_RM = teams[team_num * 4 + 1]
	Team.Enemy_LM = teams[team_num * 4 + 2]
	Team.Enemy_ST = teams[team_num * 4 + 3]
	print("set team")

var did_gameplay_tutorial:bool = false
var did_roster_tutorial1:bool = false
var bought_a_pack:bool = false
var swapped_a_player:bool = false
