extends Node

# for calendar ans date_label
const weekdaystring = ["일","월","화","수","목","금","토"]

# for calendar
var colors_dark = {
	weekday = [
		Color.RED.lightened(0.5),  # sunday
		Color.WHITE,  # monday
		Color.WHITE,
		Color.WHITE,
		Color.WHITE,
		Color.WHITE,
		Color.BLUE.lightened(0.5),  # saturday
	],
	today = Color.GREEN,
	timelabel = Color.WHITE,
	datelabel = Color.WHITE,
	infolabel = Color.WHITE,
	paneloption = Color.WHITE,
	default_clear = Color.BLACK,

	# analog clock
	hour = [Color.BLUE.lightened(0.5), Color.BLUE.lightened(0.5)],
	hour2 = [Color.BLUE, Color.BLUE],
	minute = [Color.GREEN, Color.GREEN],
	second = [Color.RED.lightened(0.5), Color.RED.lightened(0.5)],
	center_circle1 = Color.GOLD,
	center_circle2 = Color.YELLOW,
	outer_circle1 = Color.GRAY,
	outer_circle2 = Color.GRAY,
	outer_circle3 = Color.GRAY,
	outer_circle4 = Color.GRAY,
	dial_num = [Color.GRAY, Color.WHITE],
	dial_360_1 = [Color.DARK_GREEN, Color.GREEN],
	dial_360_2 = [Color.ORANGE_RED, Color.DARK_RED],
	dial_90_1 = [Color.DARK_GREEN, Color.GREEN],
	dial_90_2 = [Color.ORANGE_RED, Color.DARK_RED],
	dial_30 = [Color.DARK_GREEN, Color.GREEN],
	dial_6 = [Color.DARK_GREEN, Color.GREEN],
	dial_1 = [Color.DARK_GREEN, Color.GREEN],
}
var colors_light = 	{
	weekday = [
		Color.RED,   # sunday
		Color.BLACK,   # monday
		Color.BLACK,
		Color.BLACK,
		Color.BLACK,
		Color.BLACK,
		Color.BLUE,   # saturday
	],
	today = Color.GREEN.darkened(0.5),
	timelabel = Color.BLACK,
	datelabel = Color.BLACK,
	infolabel = Color.BLACK,
	paneloption = Color.BLACK,
	default_clear = Color.WHITE,
	# analog clock
	hour = [Color.BLUE, Color.BLUE],
	hour2 = [Color.BLUE.lightened(0.5), Color.BLUE.lightened(0.5)],
	minute = [Color.GREEN.darkened(0.5), Color.GREEN.darkened(0.5)],
	second = [Color.RED, Color.RED],
	center_circle1 = Color.GOLDENROD,
	center_circle2 = Color.DARK_GOLDENROD,
	outer_circle1 = Color.GRAY,
	outer_circle2 = Color.GRAY,
	outer_circle3 = Color.GRAY,
	outer_circle4 = Color.GRAY,
	dial_num = [Color.GRAY, Color.BLACK],
	dial_360_1 = [Color.LIGHT_CORAL, Color.DARK_RED],
	dial_360_2 = [Color.DARK_BLUE, Color.SKY_BLUE],
	dial_90_1 = [Color.LIGHT_CORAL, Color.DARK_RED],
	dial_90_2 = [Color.DARK_BLUE, Color.SKY_BLUE],
	dial_30 = [Color.LIGHT_CORAL, Color.DARK_RED],
	dial_6 = [Color.LIGHT_CORAL, Color.DARK_RED],
	dial_1 = [Color.LIGHT_CORAL, Color.DARK_RED],
}
var colors = colors_dark

# common functions
var dark_mode = true
func set_dark_mode(b :bool)->void:
	dark_mode = b
	if dark_mode :
		colors = colors_dark
	else :
		colors = colors_light
	RenderingServer.set_default_clear_color(colors.default_clear)

func make_shadow_color(co :Color)->Color:
	if dark_mode:
		return co.darkened(0.5)
	else :
		return co.lightened(0.5)

func get_color_mat(co: Color)->Material:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = co
	mat.metallic = 1
	mat.clearcoat = true
	return mat
