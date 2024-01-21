extends Node3D

const sect_width :float = 34*2
var calendar_pos_list = [Vector3(0,0,-sect_width/2),Vector3(0,0,sect_width/2)]
var analogclock_pos_list = [Vector3(0,0,sect_width/2),Vector3(0,0,-sect_width/2)]

func _ready() -> void:
	RenderingServer.set_default_clear_color( Global3d.colors.default_clear)
	reset_camera_pos()

	$DirectionalLight3D.look_at(Vector3.ZERO)

	$AnalogClock3d.init(sect_width/2)
	$AnalogClock3d.position = analogclock_pos_list[0]

	$Calendar3d.init(sect_width,sect_width)
	$Calendar3d.position = calendar_pos_list[0]

func reset_pos()->void:
	$Calendar3d.position = calendar_pos_list[0]
	$AnalogClock3d.position = analogclock_pos_list[0]
	$AniMove3D.stop()

func animove_toggle()->void:
	$AniMove3D.toggle()
	if not $AniMove3D.enabled:
		reset_pos()

func animove_step():
	if not $AniMove3D.enabled:
		return
	var ms = $AniMove3D.get_ms()
	match $AniMove3D.state%2:
		0:
			$AniMove3D.move_by_ms($Calendar3d, calendar_pos_list[0], calendar_pos_list[1], ms)
			$AniMove3D.move_by_ms($AnalogClock3d, analogclock_pos_list[0], analogclock_pos_list[1], ms)
		1:
			$AniMove3D.move_by_ms($Calendar3d, calendar_pos_list[1], calendar_pos_list[0], ms)
			$AniMove3D.move_by_ms($AnalogClock3d, analogclock_pos_list[1], analogclock_pos_list[0], ms)
		_:
			print_debug("invalid state", $AniMove3D.state)

func reset_camera_pos()->void:
	$Camera3D.position = Vector3(-1,sect_width/1.35,0)
	$Camera3D.look_at(Vector3.ZERO)

var camera_move = false
func _process(_delta: float) -> void:
	animove_step()
	var t = Time.get_unix_time_from_system() /-3.0
	if camera_move:
		$Camera3D.position = Vector3(sin(t)*sect_width/2 ,sect_width, cos(t)*sect_width/2  )
		$Camera3D.look_at(Vector3.ZERO)

# esc to exit
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			get_tree().quit()
		elif event.keycode == KEY_ENTER:
			camera_move = !camera_move
			if camera_move == false:
				reset_camera_pos()
		else:
			pass

	elif event is InputEventMouseButton and event.is_pressed():
		pass


var old_minute_dict = Time.get_datetime_dict_from_system() # datetime dict
func _on_timer_timeout() -> void:
	var time_now_dict = Time.get_datetime_dict_from_system()
	if old_minute_dict["minute"] != time_now_dict["minute"]:
		$AniMove3D.start_with_step(1)
		old_minute_dict = time_now_dict
