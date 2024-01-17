extends Node3D

var tz_shift :float = 9.0

var hour_hand_base :Node3D
var minute_hand_base :Node3D
var second_hand_base :Node3D

func _ready() -> void:
	make_hands()
	make_dial(35, Color.WHITE)

func _process(delta: float) -> void:
	update_clock()

func make_hands()->void:
	var bar_color = Color.WHITE
	var mat = MatCache.get_color_mat(bar_color)
	mat.emission_enabled = true
	mat.emission = bar_color
	var center = new_cylinder(1,1,1, mat)
	add_child(center)

	hour_hand_base = make_hand(Color.SKY_BLUE,Vector3(20,0.1,1))
	hour_hand_base.position.y = 0.1*1

	minute_hand_base = make_hand(Color.GREEN,Vector3(30,0.1,0.7))
	minute_hand_base.position.y = 0.1*2

	second_hand_base = make_hand(Color.RED,Vector3(50,0.1,0.5))
	second_hand_base.position.y = 0.1*3

func make_hand(co :Color, size: Vector3)->Node3D:
	var hand_base = Node3D.new()
	add_child(hand_base)
	var bar_color = co
	var mat = MatCache.get_color_mat(bar_color)
	mat.emission_enabled = true
	mat.emission = bar_color
	var hand = new_box(size, mat)
	hand.position.x = size.x / 4
	hand_base.add_child(hand)
	return hand_base

func make_dial(r :float, co :Color):
	var mat = MatCache.get_color_mat(co)
	mat.emission_enabled = true
	mat.emission = co
	for i in 360 :
		var bar_center = Vector3(sin(i*2*PI/360)*r,0, cos(i*2*PI/360)*r)
		var bar_rot = deg2rad(i+90)
		if i == 0:
			var bar_size = Vector3(3,0.1,0.3)
			var bar = new_box(bar_size, mat)
			bar.rotation.y = bar_rot
			bar.position = bar_center
			add_child(bar)
		elif i % 90 ==0:
			var bar_size = Vector3(2,0.1,0.2)
			var bar = new_box(bar_size, mat)
			bar.rotation.y = bar_rot
			bar.position = bar_center
			add_child(bar)
		elif i % 30 == 0 :
			var bar_size = Vector3(1,0.1,0.1)
			var bar = new_box(bar_size, mat)
			bar.rotation.y = bar_rot
			bar.position = bar_center
			add_child(bar)
		elif i % 6 == 0 :
			var bar_size = Vector3(0.5,0.1,0.1)
			var bar = new_box(bar_size, mat)
			bar.rotation.y = bar_rot
			bar.position = bar_center
			add_child(bar)
		else :
			var bar_size = Vector3(0.1,0.1,0.1)
			var bar = new_box(bar_size, mat)
			bar.rotation.y = bar_rot
			bar.position = bar_center
			add_child(bar)


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
