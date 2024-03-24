extends Node3D

var tz_shift :float = 9.0

var hour_hand_base :Node3D
var minute_hand_base :Node3D
var second_hand_base :Node3D
var timelabel : MeshInstance3D
var infolabel : MeshInstance3D

var info_text :InfoText

func init(r :float, config :Dictionary) -> void:
	var plane = Global3d.new_cylinder( r/60,  r,r, Global3d.get_color_mat(Global3d.colors.clockbg ) )
	plane.position.y = -r/60
	add_child(plane)

	make_hands(r)
	make_dial(r)

	var cc = Global3d.new_cylinder(r/30,r/50,r/50, Global3d.get_color_mat(Global3d.colors.center_circle1))
	cc.position.y = r/30/2
	add_child(cc)
	var cc2 = Global3d.new_torus(r/20, r/40, Global3d.get_color_mat(Global3d.colors.center_circle2))
	#cc2.position.y = r/20/2
	add_child( cc2 )

	# add time label
	timelabel = Global3d.new_text(r/2.2, Global3d.get_color_mat(Global3d.colors.datelabel), "00:00:00")
	timelabel.rotation.x = Global3d.deg2rad(-90)
	timelabel.rotation.z = Global3d.deg2rad(-90)
	timelabel.position = Vector3(r/3.0, 0, 0)
	add_child(timelabel)

	# add info text label
	infolabel = Global3d.new_text(r/4, Global3d.get_color_mat(Global3d.colors.infolabel), "No info")
	infolabel.rotation.x = Global3d.deg2rad(-90)
	infolabel.rotation.z = Global3d.deg2rad(-90)
	infolabel.position = Vector3(-r/2.5, 0, 0)
	add_child(infolabel)

	info_text = InfoText.new()
	add_child(info_text)
	info_text.init_request(config.weather_url,config.dayinfo_url,config.todayinfo_url)
	info_text.text_updated.connect(update_info_text)

func update_info_text(t :String)->void:
	set_mesh_text(infolabel, t)

func update_req_url(cfg:Dictionary)->void:
	info_text.update_urls(cfg.weather_url,cfg.dayinfo_url,cfg.todayinfo_url)
	info_text.force_update()

func set_mesh_text(sp:MeshInstance3D, text :String)->void:
	sp.mesh.text = text

var old_time_dict = {"second":0} # datetime dict
func _process(_delta: float) -> void:
	update_clock()
	var time_now_dict = Time.get_datetime_dict_from_system()
	if old_time_dict["second"] != time_now_dict["second"]:
		old_time_dict = time_now_dict
		set_mesh_text(timelabel, "%02d:%02d:%02d" % [time_now_dict["hour"] , time_now_dict["minute"] ,time_now_dict["second"]  ] )

func make_hands(r :float)->void:
	hour_hand_base = make_hand(Global3d.colors.hour ,Vector3(r*0.8,r/180,r/36))
	hour_hand_base.position.y = r/180*1

	minute_hand_base = make_hand(Global3d.colors.minute, Vector3(r*1.0,r/180,r/54))
	minute_hand_base.position.y = r/180*2

	second_hand_base = make_hand(Global3d.colors.second, Vector3(r*1.3,r/180,r/72))
	second_hand_base.position.y = r/180*3

func make_hand(co :Color, size: Vector3)->Node3D:
	var hand_base = Node3D.new()
	add_child(hand_base)
	var hand = Global3d.new_box(size, Global3d.get_color_mat(co))
	hand.position.x = size.x / 4
	hand_base.add_child(hand)
	return hand_base

func make_dial(r :float):
	var mat = Global3d.get_color_mat(Global3d.colors.dial_1)
	var num_mat = Global3d.get_color_mat(Global3d.colors.dial_num)
	for i in 360 :
		var bar_center = Vector3(sin(Global3d.deg2rad(-i+90))*r,0, cos(Global3d.deg2rad(-i+90))*r)
		var bar_rot = Global3d.deg2rad(-i)
		if i % 30 == 0 :
			var bar_size = Vector3(r/18,r/60,r/180)
			var bar = Global3d.new_box(bar_size, mat)
			bar.rotation.y = bar_rot
			bar.position = bar_center*0.97
			bar.position.y = 0
			add_child(bar)
			if i == 0 :
				add_child(new_dial_num(r,bar_center, num_mat,"12"))
			else:
				add_child(new_dial_num(r,bar_center, num_mat, "%d" % [i/30] ))
		elif i % 6 == 0 :
			var bar_size = Vector3(r/24,r/60,r/240) #Vector3(r/48,r/60,r/480)
			var bar = Global3d.new_box(bar_size, mat)
			bar.rotation.y = bar_rot
			bar.position = bar_center*0.98
			bar.position.y = 0
			add_child(bar)
		else :
			var bar_size = Vector3(r/72,r/60,r/720)
			var bar = Global3d.new_box(bar_size, mat)
			bar.rotation.y = bar_rot
			bar.position = bar_center*0.99
			bar.position.y = 0
			add_child(bar)

func new_dial_num(r :float, p :Vector3, mat :Material, text :String)->MeshInstance3D:
	var t = Global3d.new_text(r/4, mat, text)
	t.rotation.x = Global3d.deg2rad(-90)
	#t.rotation.y = deg2rad(90)
	t.rotation.z = Global3d.deg2rad(-90)
	t.position = p *0.85
	return t

func update_clock():
	var ms = Time.get_unix_time_from_system()
	var second = ms - int(ms/60)*60
	ms = ms / 60
	var minute = ms - int(ms/60)*60
	ms = ms / 60
	var hour = ms - int(ms/24)*24 + tz_shift
	second_hand_base.rotation.y = -second2rad(second)
	minute_hand_base.rotation.y = -minute2rad(minute)
	hour_hand_base.rotation.y = -hour2rad(hour)

func second2rad(sec :float) -> float:
	return 2.0*PI/60.0*sec

func minute2rad(m :float) -> float:
	return 2.0*PI/60.0*m

func hour2rad(hour :float) -> float:
	return 2.0*PI/12.0*hour

