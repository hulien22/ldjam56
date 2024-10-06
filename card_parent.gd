extends Node3D

var char_name: TextMesh
var char_stats: TextMesh

func _ready() -> void:
	char_name = $Card/Name.mesh
	char_stats = $Card/Stats.mesh
	$Card.set_physics_process(false)

func enable_card():
	$Card.set_physics_process(true)

func set_data(data: Character):
	char_name.text = data.name
	char_stats.text = str(data.determination) + "\n" + str(data.cuteness) + "\nTiny\n" + data.nationality
