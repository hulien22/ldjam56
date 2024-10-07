extends Node3D

var char_name: TextMesh
var char_stats: TextMesh
@export var textures: Array[Texture]
@export var stickers: Array[Texture]

@onready var internal_card: Card = $Card
var starting_pos: Vector3

func _ready() -> void:
	char_name = $Card/Name.mesh
	char_stats = $Card/Stats.mesh
	reset_card()
	
func set_big():
	var x: Node3D = $Card/CardImage/SubViewport/Subscene
	x.scale *= 4
	var z: OmniLight3D = $Card/CardImage/SubViewport/Subscene/OmniLight3D
	z.light_energy *= 4

func enable_card():
	$Card.set_physics_process(true)

func reset_card():
	$Card.set_physics_process(false)
	$Card.rot = PI
	for x in $Card/CardImage/SubViewport/Subscene/Scaler.get_children():
		$Card/CardImage/SubViewport/Subscene/Scaler.remove_child(x)

func set_data(data: Character):
	var x: Mesh = $Card.mesh
	var y: Mesh = $Card/Sitcker.mesh
	if data.chance == 0:
		print("LEGOO")
		x.material.set_shader_parameter("threshold", 0.1)
		y.material.set_shader_parameter("threshold", 0.1)
	else:
		x.material.set_shader_parameter("threshold", 0)
		y.material.set_shader_parameter("threshold", 0)
	x.material.set_shader_parameter("texture_albedo", textures[data.chance])
	y.material.set_shader_parameter("texture_albedo", stickers[data.chance])
	char_name.text = data.name.replace(" ", "\n")
	char_stats.text = str(data.determination) + "\n" + str(data.cuteness) + "\nTiny\n" + data.nationality
	var model = data.model.instantiate()
	#model.enable(false)
	$Card/CardImage/SubViewport/Subscene/Scaler.add_child(model)
