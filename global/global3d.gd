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
	timelabel = Color.WHITE,
	datelabel = Color.WHITE,
	infolabel = Color.WHITE,
	paneloption = Color.WHITE,
	default_clear = Color.DIM_GRAY,

	# analog clock
	hour = Color.BLUE,
	minute = Color.GREEN,
	second = Color.RED,
	center_circle1 = Color.GOLD,
	center_circle2 = Color.YELLOW,
	outer_circle1 = Color.GRAY,
	outer_circle2 = Color.GRAY,
	outer_circle3 = Color.GRAY,
	outer_circle4 = Color.GRAY,
	dial_num = Color.LIGHT_GRAY,
	dial_1 = Color.LIGHT_YELLOW,
}

func get_color_mat(co: Color)->Material:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = co
	mat.metallic = 1
	mat.clearcoat = true
	return mat
