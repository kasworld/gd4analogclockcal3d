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

	# analog clock
	hour = Color.BLUE,
	minute = Color.GREEN,
	second = Color.RED,
	center_circle1 = Color.CYAN,
	center_circle2 = Color.MAGENTA,
	dial_num = Color.LIGHT_GRAY,
	dial_1 = Color.WHEAT,
}

func get_color_mat(co: Color)->Material:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = co
	mat.metallic = 1
	mat.clearcoat = true
	return mat
