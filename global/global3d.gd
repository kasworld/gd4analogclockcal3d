extends Node

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

	# analog clock
	hour = Color.ROYAL_BLUE,
	minute = Color.MEDIUM_SPRING_GREEN,
	second = Color.ORANGE_RED,
	center_circle1 = Color.PALE_GOLDENROD,
	center_circle2 = Color.LIGHT_GOLDENROD,
	dial_num = Color.LIGHT_GRAY,
	dial_1 = Color.WHEAT,
	clockbg = Color.BLACK.lightened(0.3),

	default_clear = Color.BLACK,
}

func deg2rad(deg :float) ->float :
	return deg * 2 * PI / 360

func get_color_mat(co: Color)->Material:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = co
	mat.metallic = 1
	mat.clearcoat = true
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

func new_plane(size :Vector2, mat :Material)->MeshInstance3D:
	var mesh = PlaneMesh.new()
	mesh.size = size
	mesh.material = mat
	var sp = MeshInstance3D.new()
	sp.mesh = mesh
	return sp
