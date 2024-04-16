extends Node3D

var timelabel : MeshInstance3D
var infolabel : MeshInstance3D

var info_text :InfoText

func init(r :float,d:float, fsize :float, config :Dictionary) -> void:
	$AnalogClock3d.init(r, d, fsize, 9.0, true)

	var text_depth = d*0.2
	# add time label
	timelabel = Global3d.new_text(fsize*2.5,text_depth, Global3d.get_color_mat(Global3d.colors.datelabel), "00:00:00")
	timelabel.rotation.x = deg_to_rad(-90)
	timelabel.rotation.z = deg_to_rad(-90)
	timelabel.position = Vector3(r*0.25, text_depth*0.5, 0)
	add_child(timelabel)

	# add info text label
	infolabel = Global3d.new_text(fsize*1.1,text_depth, Global3d.get_color_mat(Global3d.colors.infolabel), "No info")
	infolabel.rotation.x = deg_to_rad(-90)
	infolabel.rotation.z = deg_to_rad(-90)
	infolabel.position = Vector3(-r*0.35, text_depth*0.5, 0)
	add_child(infolabel)

	info_text = InfoText.new()
	add_child(info_text)
	info_text.init_request(config.weather_url,config.dayinfo_url,config.todayinfo_url)
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
