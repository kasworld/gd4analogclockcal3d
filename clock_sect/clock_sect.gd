extends Node3D

# for calendar
var colors = {
	timelabel = Color.WHITE,
	datelabel = Color.WHITE,
	infolabel = Color.WHITE,
}

var timelabel : MeshInstance3D
var infolabel : MeshInstance3D

var info_text :InfoText

func init(r :float,d:float, fsize :float, config :Dictionary) -> void:
	$AnalogClock3d.init(r, d, fsize, 9.0, true)
	#$AnalogClock3d.rotate_y(PI/2)
	#$AnalogClock3d.rotate_x(PI/2)

	var text_depth = d*0.2
	# add time label
	timelabel = new_text(fsize*2.5,text_depth, get_color_mat(colors.datelabel), "00:00:00")
	timelabel.position = Vector3(0, r*0.2, text_depth*0.5)
	add_child(timelabel)

	# add info text label
	infolabel = new_text(fsize*1.1,text_depth, get_color_mat(colors.infolabel), "No info")
	infolabel.position = Vector3(0, -r*0.35, text_depth*0.5)
	add_child(infolabel)

	info_text = InfoText.new()
	add_child(info_text)
	info_text.init_request(
		config.base_url + config.weather_file,
		config.base_url + config.dayinfo_file,
		config.base_url + config.todayinfo_file)
	info_text.text_updated.connect(_on_update_info_text)

var old_time_dict = {"second":0} # datetime dict
func _process(_delta: float) -> void:
	var time_now_dict = Time.get_datetime_dict_from_system()
	if old_time_dict["second"] != time_now_dict["second"]:
		old_time_dict = time_now_dict
		set_mesh_text(timelabel, "%02d:%02d:%02d" % [time_now_dict["hour"] , time_now_dict["minute"] ,time_now_dict["second"]  ] )

func _on_update_info_text(t :String)->void:
	set_mesh_text(infolabel, t )

func update_req_url(cfg:Dictionary)->void:
	info_text.update_urls(cfg.weather_url,cfg.dayinfo_url,cfg.todayinfo_url)
	info_text.force_update()

func set_mesh_text(sp:MeshInstance3D, text :String)->void:
	sp.mesh.text = text

var font = preload("res://font/HakgyoansimBareondotumR.ttf")
func new_text(fsize :float, fdepth :float, mat :Material, text :String)->MeshInstance3D:
	var mesh = TextMesh.new()
	mesh.font = font
	mesh.depth = fdepth
	mesh.pixel_size = fsize / 16
	mesh.text = text
	mesh.material = mat
	var sp = MeshInstance3D.new()
	sp.mesh = mesh
	return sp

func get_color_mat(co: Color)->Material:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = co
	#mat.metallic = 1
	#mat.clearcoat = true
	return mat
