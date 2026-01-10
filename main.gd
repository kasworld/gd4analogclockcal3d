extends Node3D

#var version_key = "version"
var editable_keys = [
	"weather_url",
	"dayinfo_url",
	"todayinfo_url",
	]

var file_name = "gd4analogclockcal3d_config.json"
var config = {
	"version" : "gd4analogclockcal3d 5.0.0",
	"weather_url" : "http://192.168.0.10/weather.txt",
	"dayinfo_url" : "http://192.168.0.10/dayinfo.txt",
	"todayinfo_url" : "http://192.168.0.10/todayinfo.txt",
}
func config_changed(cfg :Dictionary):
	for k in cfg:
		config[k]=cfg[k]

var WorldSize := Vector3(160,90,80)
func _ready() -> void:
	config = Config.load_or_save(file_name,config,"version" )

	var sect_width = WorldSize.x/2
	var calendar_pos = Vector3(-sect_width/2,0,0)
	var analogclock_pos = Vector3(sect_width/2,0,0)
	$AxisArrow3D.set_size(WorldSize.length()/10).set_colors()

	$AnimationPlayer.get_animation("RESET").track_set_key_value(0,0, analogclock_pos)
	$AnimationPlayer.get_animation("RESET").track_set_key_value(1,0, calendar_pos)

	$AnimationPlayer.get_animation("Move1").track_set_key_value(0,0, analogclock_pos)
	$AnimationPlayer.get_animation("Move1").track_set_key_value(0,1, calendar_pos)
	$AnimationPlayer.get_animation("Move1").track_set_key_value(1,0, calendar_pos)
	$AnimationPlayer.get_animation("Move1").track_set_key_value(1,1, analogclock_pos)

	$AnimationPlayer.get_animation("Move2").track_set_key_value(0,0, calendar_pos)
	$AnimationPlayer.get_animation("Move2").track_set_key_value(0,1, analogclock_pos)
	$AnimationPlayer.get_animation("Move2").track_set_key_value(1,0, analogclock_pos)
	$AnimationPlayer.get_animation("Move2").track_set_key_value(1,1, calendar_pos)


	var depth = sect_width/20
	$ClockSect.init(sect_width/2, depth, sect_width*0.06, config)
	$ClockSect.position = analogclock_pos

	$Calendar3d.init(sect_width,sect_width,depth, sect_width*0.09, true)
	$Calendar3d.position = calendar_pos

	$FixedCameraLight.set_center_pos_far(Vector3.ZERO, Vector3(-1,0,sect_width),  WorldSize.length()*3)
	$MovingCameraLightHober.set_center_pos_far(Vector3.ZERO, Vector3(-1,0,sect_width),  WorldSize.length()*3)
	$MovingCameraLightAround.set_center_pos_far(Vector3.ZERO, Vector3(-1,0,sect_width),  WorldSize.length()*3)
	$FixedCameraLight.make_current()

	var vp_size = get_viewport().get_visible_rect().size
	var optrect = Rect2( vp_size.x * 0.1 ,vp_size.y * 0.3 , vp_size.x * 0.8 , vp_size.y * 0.4 )
	$PanelOption.init(file_name,config,editable_keys, optrect )
	$PanelOption.config_changed.connect(config_changed)
	$PanelOption.config_reset_req.connect(panel_config_reset_req)

func reset_pos()->void:
	$AnimationPlayer.play("RESET")

var move_order := 0
func start_move_animation():
	if move_order == 0 :
		$AnimationPlayer.play("Move1")
		move_order = 1
	else :
		$AnimationPlayer.play("Move2")
		move_order = 0

func _notification(what: int) -> void:
	# app resume on android
	if what == NOTIFICATION_APPLICATION_RESUMED :
		pass

func _process(_delta: float) -> void:
	rot_by_accel()
	var now := Time.get_unix_time_from_system() /-3.0
	if $MovingCameraLightHober.is_current_camera():
		$MovingCameraLightHober.move_hober_around_z(now/2.3, Vector3.ZERO, WorldSize.length()/2, WorldSize.length()/4 )
	elif $MovingCameraLightAround.is_current_camera():
		$MovingCameraLightAround.move_wave_around_y(now/2.3, Vector3.ZERO, WorldSize.length()/2, WorldSize.length()/4 )

var key2fn = {
	KEY_ESCAPE:_on_button_esc_pressed,
	KEY_ENTER:_on_카메라변경_pressed,
	KEY_PAGEUP:_on_button_fov_up_pressed,
	KEY_PAGEDOWN:_on_button_fov_down_pressed,

	KEY_TAB : _on_button_option_pressed,
	KEY_SPACE : _on_button_option_pressed,
	KEY_Z : start_move_animation,
}
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		var fn = key2fn.get(event.keycode)
		if fn != null:
			fn.call()
		if $FixedCameraLight.is_current_camera():
			var fi = FlyNode3D.Key2Info.get(event.keycode)
			if fi != null:
				FlyNode3D.fly_node3d($FixedCameraLight, fi)
	elif event is InputEventMouseButton and event.is_pressed():
		pass

func _on_button_esc_pressed() -> void:
	get_tree().quit()

func _on_카메라변경_pressed() -> void:
	MovingCameraLight.NextCamera()

func _on_button_fov_up_pressed() -> void:
	MovingCameraLight.GetCurrentCamera().fov_camera_inc()

func _on_button_fov_down_pressed() -> void:
	MovingCameraLight.GetCurrentCamera().fov_camera_dec()

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
	$ClockSect.rotation.z = -rad
	$Calendar3d.rotation.z = -rad

var old_time_dict = Time.get_datetime_dict_from_system() # datetime dict
var old_minute_dict = Time.get_datetime_dict_from_system() # datetime dict
func _on_timer_timeout() -> void:
	var time_now_dict = Time.get_datetime_dict_from_system()
	if old_minute_dict["minute"] != time_now_dict["minute"]:
		start_move_animation()
		old_minute_dict = time_now_dict
