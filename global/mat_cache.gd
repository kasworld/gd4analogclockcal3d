extends Node

var _mat_cache ={}

func get_color_mat(co: Color)->Material:
	if _mat_cache.get(co) != null :
		return _mat_cache.get(co)
	var mat = StandardMaterial3D.new()
	mat.albedo_color = co
	mat.metallic = 1
	mat.clearcoat = true
	_mat_cache[co] = mat
	return mat
