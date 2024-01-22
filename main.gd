extends Node3D

#var version_key = "version"
var editable_keys = [
	"weather_url",
	"dayinfo_url",
	"todayinfo_url",
	]

var file_name = "gd4analogclockcal3d_config.json"
var config = {
	"version" : "gd4analogclockcal3d 2.2.0",
	"weather_url" : "http://192.168.0.10/weather.txt",
	"dayinfo_url" : "http://192.168.0.10/dayinfo.txt",
	"todayinfo_url" : "http://192.168.0.10/todayinfo.txt",
}
func config_changed(cfg :Dictionary):
	#update config
	for k in cfg:
		config[k]=cfg[k]

const sect_width :float = 34*2
var calendar_pos_list = [Vector3(0,0,-sect_width/2),Vector3(0,0,sect_width/2)]
var analogclock_pos_list = [Vector3(0,0,sect_width/2),Vector3(0,0,-sect_width/2)]

func _ready() -> void:
	config = Config.load_or_save(file_name,config,"version" )
	print_debug(config)
	RenderingServer.set_default_clear_color( Global3d.colors.default_clear)
	reset_camera_pos()

	$DirectionalLight3D.look_at(Vector3.ZERO)

	$AnalogClock3d.init(sect_width/2,config)
	$AnalogClock3d.position = analogclock_pos_list[0]

	$Calendar3d.init(sect_width,sect_width)
	$Calendar3d.position = calendar_pos_list[0]

	var vp_rect = Rect2(0,0,1920,1080)
	var optrect = Rect2( vp_rect.size.x * 0.1 ,vp_rect.size.y * 0.3 , vp_rect.size.x * 0.8 , vp_rect.size.y * 0.4 )
	$PanelOption.init(file_name,config,editable_keys, optrect )
	$PanelOption.config_changed.connect(config_changed)
	$PanelOption.config_reset_req.connect(panel_config_reset_req)

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
	rot_by_accel()
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
		elif event.keycode == KEY_TAB:
			_on_button_option_pressed()
		elif event.keycode == KEY_SPACE:
			_on_button_option_pressed()
		else:
			light_state = (light_state+1)%3
			light_on(light_state)

	elif event is InputEventMouseButton and event.is_pressed():
		light_state = (light_state+1)%3
		light_on(light_state)

func _notification(what: int) -> void:
	# app resume on android
	if what == NOTIFICATION_APPLICATION_RESUMED :
		set_light_by_time()

func _on_button_option_pressed() -> void:
	$PanelOption.visible = not $PanelOption.visible

func _on_auto_hide_option_panel_timeout() -> void:
	$PanelOption.hide()

func panel_config_reset_req()->void:
	$PanelOption.config_to_control(file_name,config,editable_keys)

var oldvt = Vector2(0,-100)
func rot_by_accel()->void:
	var vt = Input.get_accelerometer()
	if  vt != Vector3.ZERO :
		oldvt = (Vector2(vt.x,vt.y) + oldvt).normalized() *100
		var rad = oldvt.angle_to(Vector2(0,-1))
		rotate_all(rad)
	else :
		vt = Input.get_last_mouse_velocity()/100
		if vt == Vector2.ZERO :
			vt = Vector2(0,-5)
		oldvt = (Vector2(vt.x,vt.y) + oldvt).normalized() *100
		var rad = oldvt.angle_to(Vector2(0,-1))
		rotate_all(rad)

func rotate_all(rad :float):
	$AnalogClock3d.rotation.y = -rad
	$Calendar3d.rotation.y = -rad

var light_state = 0
func set_light_by_time()->void:
	var now = Time.get_datetime_dict_from_system()
	if now["hour"] < 6 or now["hour"] >= 18 :
		light_on(2)
	else :
		light_on(0)

func light_on(s :int)->void:
	match s %3 :
		0: # all on
			$OmniLight3D.visible = true
			$DirectionalLight3D.visible = true
		1:
			$OmniLight3D.visible = true
			$DirectionalLight3D.visible = false
		2:
			$OmniLight3D.visible = false
			$DirectionalLight3D.visible = true

var old_time_dict = Time.get_datetime_dict_from_system() # datetime dict
var old_minute_dict = Time.get_datetime_dict_from_system() # datetime dict
func _on_timer_timeout() -> void:
	var time_now_dict = Time.get_datetime_dict_from_system()
	if old_minute_dict["minute"] != time_now_dict["minute"]:
		$AniMove3D.start_with_step(1)
		old_minute_dict = time_now_dict

	if old_time_dict["hour"] != time_now_dict["hour"]:
		old_time_dict = time_now_dict
		match time_now_dict["hour"]:
			6:
				light_on(0)
			18:
				light_on(2)
			_:
				pass


