extends Node

#class_name Global3d

# for calendar ans date_label
const weekdaystring = ["일","월","화","수","목","금","토"]

# for calendar
var colors = {
	weekday = [
		Color.RED,  # sunday
		Color.WHITE,  # monday
		Color.WHITE,
		Color.WHITE,
		Color.WHITE,
		Color.WHITE,
		Color.BLUE,  # saturday
	],
	today = Color.GREEN,
	calbg = Color.BLACK.lightened(0.2),

	timelabel = Color.WHITE,
	datelabel = Color.WHITE,
	infolabel = Color.WHITE,

	# analog clock
	hour = Color.ROYAL_BLUE,
	minute = Color.MEDIUM_SPRING_GREEN,
	second = Color.ORANGE_RED,
	center_circle1 = Color.PALE_GOLDENROD,
	center_circle2 = Color.LIGHT_GOLDENROD,
	dial_num = Color.DARK_GOLDENROD,
	dial_bar = Color.GOLDENROD,
	clockbg = Color.BLACK.lightened(0.3),

	default_clear = Color.BLACK,
}

func get_color_mat(co: Color)->Material:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = co
	#mat.metallic = 1
	#mat.clearcoat = true
	return mat

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
	mesh.radial_segments = clampi( int((r1+r2)*2) , 64, 360)
	mesh.material = mat
	var sp = MeshInstance3D.new()
	sp.mesh = mesh
	return sp

var font = preload("res://HakgyoansimBareondotumR.ttf")
func new_text(fsize :float, fdepth :float, mat :Material, text :String)->MeshInstance3D:
	var mesh = TextMesh.new()
	mesh.font = font
	mesh.depth = fdepth
	mesh.pixel_size = fsize / 100
	mesh.font_size = fsize
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

func new_plane(size :Vector2, mat :Material)->MeshInstance3D:
	var mesh = PlaneMesh.new()
	mesh.size = size
	mesh.material = mat
	var sp = MeshInstance3D.new()
	sp.mesh = mesh
	return sp
