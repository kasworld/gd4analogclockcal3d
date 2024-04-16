extends Node3D

#var version_key = "version"
var editable_keys = [
	"weather_url",
	"dayinfo_url",
	"todayinfo_url",
	]

var file_name = "gd4analogclockcal3d_config.json"
var config = {
	"version" : "gd4analogclockcal3d 3.4.0",
	"weather_url" : "http://192.168.0.10/weather.txt",
	"dayinfo_url" : "http://192.168.0.10/dayinfo.txt",
	"todayinfo_url" : "http://192.168.0.10/todayinfo.txt",
}
func config_changed(cfg :Dictionary):
	for k in cfg:
		config[k]=cfg[k]

var vp_size :Vector2
var sect_width :float
var calendar_pos_list :Array
var analogclock_pos_list :Array

func _ready() -> void:
	vp_size = get_viewport().get_visible_rect().size
	config = Config.load_or_save(file_name,config,"version" )
	RenderingServer.set_default_clear_color( Global3d.colors.default_clear)

	vp_size = get_viewport().get_visible_rect().size
	sect_width = min(vp_size.x/2,vp_size.y)
	calendar_pos_list = [Vector3(0,0,-sect_width/2),Vector3(0,0,sect_width/2)]
	analogclock_pos_list = calendar_pos_list.duplicate()
	analogclock_pos_list.reverse()

	var depth = sect_width/20
	$ClockSect.init(sect_width/2, depth, 100, config)
	$ClockSect.position = analogclock_pos_list[0]

	$Calendar3d.init(sect_width,sect_width,depth, 160, true)
	$Calendar3d.position = calendar_pos_list[0]

	$DirectionalLight3D.look_at(Vector3.ZERO)
	reset_camera_pos()

	var optrect = Rect2( vp_size.x * 0.1 ,vp_size.y * 0.3 , vp_size.x * 0.8 , vp_size.y * 0.4 )
	$PanelOption.init(file_name,config,editable_keys, optrect )
	$PanelOption.config_changed.connect(config_changed)
	$PanelOption.config_reset_req.connect(panel_config_reset_req)

func reset_pos()->void:
	$Calendar3d.position = calendar_pos_list[0]
	$ClockSect.position = analogclock_pos_list[0]
	$AniMove.stop()

func animove_toggle()->void:
	$AniMove.toggle()
	if not $AniMove.enabled:
		reset_pos()

func animove_step():
	if not $AniMove.enabled:
		return
	var ms = $AniMove.get_ms()
	$AniMove.move_position($Calendar3d, calendar_pos_list, ms)
	$AniMove.move_position($ClockSect, analogclock_pos_list, ms)

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
	#$ClockSect.rotate_x(_delta)
	#$Calendar3d.rotate_z(_delta)

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

func _notification(what: int) -> void:
	# app resume on android
	if what == NOTIFICATION_APPLICATION_RESUMED :
		pass

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
	$ClockSect.rotation.y = -rad
	$Calendar3d.rotation.y = -rad

var old_time_dict = Time.get_datetime_dict_from_system() # datetime dict
var old_minute_dict = Time.get_datetime_dict_from_system() # datetime dict
func _on_timer_timeout() -> void:
	var time_now_dict = Time.get_datetime_dict_from_system()
	if old_minute_dict["minute"] != time_now_dict["minute"]:
		$AniMove.start_with_step(1)
		old_minute_dict = time_now_dict
