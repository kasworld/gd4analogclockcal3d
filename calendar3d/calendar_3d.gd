extends Node3D

# 7x7
var calendar_labels = []

func init(w :float, h:float)->void:
	var plane = Global3d.new_plane(Vector2(w,h), Global3d.get_color_mat(Global3d.colors.calbg ) )
	plane.position.y = -w/180
	add_child(plane)

	init_calendar(w/7,h/7)
	update_calendar()

func init_calendar(w :float, h :float)->void:
	# prepare calendar
	for i in range(7): # week title + 6 week
		var ln = []
		for j in Global3d.weekdaystring.size():
			var co = Global3d.colors.weekday[j]
			var mat = Global3d.get_color_mat(co)
			var lb = Global3d.new_text(h*2, mat, Global3d.weekdaystring[j])
			lb.rotation.x = Global3d.deg2rad(-90)
			#t.rotation.y = deg2rad(90)
			lb.rotation.z = Global3d.deg2rad(-90)
			lb.position = Vector3(3*h - i*h  , 0, j*w - 3*w)
			ln.append(lb)
			add_child(lb)
		calendar_labels.append(ln)

func set_mesh_color(sp:MeshInstance3D, co:Color)->void:
	sp.mesh.material = Global3d.get_color_mat(co)

func set_mesh_text(sp:MeshInstance3D, text :String)->void:
	sp.mesh.text = text

func update_calendar()->void:
	var tz = Time.get_time_zone_from_system()
	var today = int(Time.get_unix_time_from_system()) +tz["bias"]*60
	var today_dict = Time.get_date_dict_from_unix_time(today)
	var day_index = today - (7 + today_dict["weekday"] )*24*60*60 #datetime.timedelta(days=(-today.weekday() - 7))

	for wd in range(7):
		var curLabel = calendar_labels[0][wd]
		var co = Global3d.colors.weekday[wd]
		if wd == today_dict["weekday"] :
			co = Global3d.colors.today
		set_mesh_color(curLabel, co)

	for week in range(6):
		for wd in range(7):
			var day_index_dict = Time.get_date_dict_from_unix_time(day_index)
			var curLabel = calendar_labels[week+1][wd]
			set_mesh_text(curLabel, "%d" % day_index_dict["day"] )
			var co = Global3d.colors.weekday[wd]
			if day_index_dict["month"] != today_dict["month"]:
				co = co.darkened(0.5)
			elif day_index_dict["day"] == today_dict["day"]:
				co = Global3d.colors.today
			set_mesh_color(curLabel, co)
			day_index += 24*60*60

var old_time_dict = {"day":0} # datetime dict
func _on_timer_timeout() -> void:
	var time_now_dict = Time.get_datetime_dict_from_system()

	# date changed, update datelabel, calendar
	if old_time_dict["day"] != time_now_dict["day"]:
		old_time_dict = time_now_dict
		update_calendar()
