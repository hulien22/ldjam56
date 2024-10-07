extends Node

var match_num: int = 0
var team_num: int = 0
@export var teams: Array[Character]
@export var team_names: Array[String]

func load_enemy_team():
	Team.Enemy_GK = teams[team_num * 4]
	Team.Enemy_RM = teams[team_num * 4 + 1]
	Team.Enemy_LM = teams[team_num * 4 + 2]
	Team.Enemy_ST = teams[team_num * 4 + 3]
	print("set team")
