extends Node3D
# 0 - grass
# 1 - water
# 2 - wood (browns)
# 3 - rocks
# 4 - tent fabric
# 5 - tent poles
# 6 - fire
# 7 - trees

func set_default_theme():
	for i in $model_064.get_surface_override_material_count():
		$model_064.set_surface_override_material(i, null)
	var mat: StandardMaterial3D = StandardMaterial3D.new()
	mat.albedo_color = Color("6e6e6e")
	$Base.set_surface_override_material(0, mat)

func set_candy_theme():
	var colors: Array[Color] = [Color("b53f3f"), Color("56ad3b"), Color("634100"), Color("2560cf"), Color("000000", 0), Color("000000", 0), Color("000000", 0), Color("000000", 0)]
	set_theme(colors)

func _ready() -> void:
	#set_candy_theme()
	set_default_theme()
	pass

func set_theme(colors: Array[Color]) -> void:
	for i in $model_064.get_surface_override_material_count():
		var mat: StandardMaterial3D = StandardMaterial3D.new()
		mat.albedo_color = colors[i]
		if mat.albedo_color.a == 0:
			mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		$model_064.set_surface_override_material(i, mat)
	var mat: StandardMaterial3D = StandardMaterial3D.new()
	mat.albedo_color = colors[3]
	#mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	$Base.set_surface_override_material(0, mat)
