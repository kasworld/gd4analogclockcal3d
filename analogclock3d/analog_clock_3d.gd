extends Node3D

var tz_shift :float = 9.0

var hour_hand_base :Node3D
var minute_hand_base :Node3D
var second_hand_base :Node3D

func init(r :float) -> void:
	make_hands(r)
	make_dial(r, Global3d.colors.dial_1, Global3d.colors.dial_num)

func _process(delta: float) -> void:
	update_clock()

func make_hands(r :float)->void:
	var mat = Global3d.get_color_mat(Global3d.colors.center_circle1)
	var center1 = new_cylinder(r/30,r/50,r/50, mat)
	center1.position.y = 0
	add_child(center1)

	mat = Global3d.get_color_mat(Global3d.colors.center_circle2)
	var center2 = new_torus(r/20, r/40, mat)
	center2.position.y = 0
	add_child(center2)


	hour_hand_base = make_hand(Global3d.colors.hour ,Vector3(r*0.9,r/180,r/36))
	hour_hand_base.position.y = r/180*0

	minute_hand_base = make_hand(Global3d.colors.minute, Vector3(r*1.1,r/180,r/54))
	minute_hand_base.position.y = r/180*1

	second_hand_base = make_hand(Global3d.colors.second, Vector3(r*1.2,r/180,r/72))
	second_hand_base.position.y = r/180*2

func make_hand(co :Color, size: Vector3)->Node3D:
	var hand_base = Node3D.new()
	add_child(hand_base)
	var mat = Global3d.get_color_mat(co)
	#mat.emission_enabled = true
	#mat.emission = bar_color
	var hand = new_box(size, mat)
	hand.position.x = size.x / 4
	hand_base.add_child(hand)
	return hand_base

func make_dial(r :float, co_dial :Color, co_num :Color):
	var mat = Global3d.get_color_mat(co_dial)
	var num_mat = Global3d.get_color_mat(co_num)
	for i in 360 :
		var bar_center = Vector3(sin(deg2rad(-i+90))*r,0, cos(deg2rad(-i+90))*r)
		var bar_rot = deg2rad(-i)
		if i == 0:
			var bar_size = Vector3(r/12,r/60,r/120)
			var bar = new_box(bar_size, mat)
			bar.rotation.y = bar_rot
			bar.position = bar_center
			add_child(bar)
			add_child(new_dial_num(r,bar_center, num_mat,"12"))

		elif i % 90 ==0:
			var bar_size = Vector3(r/18,r/60,r/180)
			var bar = new_box(bar_size, mat)
			bar.rotation.y = bar_rot
			bar.position = bar_center*1.01
			add_child(bar)
			add_child(new_dial_num(r,bar_center, num_mat, "%d" % [i/30] ))

		elif i % 30 == 0 :
			var bar_size = Vector3(r/24,r/60,r/240)
			var bar = new_box(bar_size, mat)
			bar.rotation.y = bar_rot
			bar.position = bar_center*1.02
			add_child(bar)
			add_child(new_dial_num(r,bar_center, num_mat, "%d" % [i/30] ))

		elif i % 6 == 0 :
			var bar_size = Vector3(r/48,r/60,r/480)
			var bar = new_box(bar_size, mat)
			bar.rotation.y = bar_rot
			bar.position = bar_center*1.03
			add_child(bar)
		else :
			var bar_size = Vector3(r/72,r/60,r/720)
			var bar = new_box(bar_size, mat)
			bar.rotation.y = bar_rot
			bar.position = bar_center*1.03
			add_child(bar)


func new_dial_num(r :float, p :Vector3, mat :Material, text :String)->MeshInstance3D:
	var t = new_text(r/2, mat, text)
	t.rotation.x = deg2rad(-90)
	#t.rotation.y = deg2rad(90)
	t.rotation.z = deg2rad(-90)
	t.position = p *0.9
	return t


func new_box(hand_size :Vector3, mat :Material)->MeshInstance3D:
	var mesh = BoxMesh.new()
	mesh.size = hand_size
	mesh.material = mat
	var sp = MeshInstance3D.new()
	sp.mesh = mesh
	return sp

func new_sphere(r :float, mat :Material)->MeshInstance3D:
	var mesh = SphereMesh.new()
	mesh.radius = r
	#mesh.radial_segments = 100
	#mesh.rings = 100
	mesh.material = mat
	var sp = MeshInstance3D.new()
	sp.mesh = mesh
	return sp

func new_cylinder(h :float, r1 :float, r2 :float, mat :Material)->MeshInstance3D:
	var mesh = CylinderMesh.new()
	mesh.height = h
	mesh.bottom_radius = r1
	mesh.top_radius = r2
	mesh.material = mat
	var sp = MeshInstance3D.new()
	sp.mesh = mesh
	return sp

func new_text(h :float, mat :Material, text :String)->MeshInstance3D:
	var mesh = TextMesh.new()
	mesh.depth = h / 30
	mesh.pixel_size = h / 50
	mesh.font_size = h
	mesh.text = text
	mesh.material = mat
	var sp = MeshInstance3D.new()
	sp.mesh = mesh
	return sp

func new_torus(r1 :float,r2 :float, mat :Material)->MeshInstance3D:
	var mesh = TorusMesh.new()
	mesh.outer_radius = r1
	mesh.inner_radius = r2
	mesh.material = mat
	var sp = MeshInstance3D.new()
	sp.mesh = mesh
	return sp


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

func deg2rad(deg :float) ->float :
	return deg * 2 * PI / 360

func second2rad(sec :float) -> float:
	return 2.0*PI/60.0*sec

func minute2rad(m :float) -> float:
	return 2.0*PI/60.0*m

func hour2rad(hour :float) -> float:
	return 2.0*PI/12.0*hour
