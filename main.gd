extends Node3D

func _ready() -> void:
	$DirectionalLight3D.look_at(Vector3.ZERO)
	$Camera3D.look_at(Vector3.ZERO)
	$AnalogClock3d.init(36)
	$Calendar3d.init(36,36)

var camera_move = true
func _process(delta: float) -> void:
	var t = Time.get_unix_time_from_system() /-3.0
	if camera_move:
		$Camera3D.position = Vector3(sin(t)*40 ,70.0, cos(t)*40  )
	$Camera3D.look_at(Vector3.ZERO)

# esc to exit
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			get_tree().quit()
		elif event.keycode == KEY_ENTER:
			camera_move = !camera_move
		else:
			update_color_with_mode(not Global3d.dark_mode)

	elif event is InputEventMouseButton and event.is_pressed():
		update_color_with_mode(not Global3d.dark_mode)

func set_color_mode_by_time()->void:
	var now = Time.get_datetime_dict_from_system()
	if now["hour"] < 6 or now["hour"] >= 18 :
		Global3d.set_dark_mode(true)
	else :
		Global3d.set_dark_mode(false)

func update_color()->void:
	$SectCalendar.update_color()
	$SectAnalogClock.update_color()

func update_color_with_mode(darkmode :bool)->void:
	Global3d.set_dark_mode(darkmode)
	$Calendar3d.update_color()
	$AnalogClock3d.update_color()

# change dark mode by time
var old_time_dict = Time.get_datetime_dict_from_system() # datetime dict
var old_minute_dict = Time.get_datetime_dict_from_system() # datetime dict
func _on_timer_day_night_timeout() -> void:
	var time_now_dict = Time.get_datetime_dict_from_system()

	if old_minute_dict["minute"] != time_now_dict["minute"]:
		$AniMove.start_with_step(1)
		old_minute_dict = time_now_dict

	if old_time_dict["hour"] != time_now_dict["hour"]:
		old_time_dict = time_now_dict
		match time_now_dict["hour"]:
			6:
				update_color_with_mode(false)
			18:
				update_color_with_mode(true)
			_:
#				update_color(not Global3d.dark_mode)
				pass

