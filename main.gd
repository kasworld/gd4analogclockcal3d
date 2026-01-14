extends Node3D

var config = {
	"base_url" : "http://192.168.0.10/",
	"weather_file" : "weather.txt",
	"dayinfo_file" : "dayinfo.txt",
	"todayinfo_file" : "todayinfo.txt",
}
var main_animation := SimpleAnimation.new()
var anipos_list := []
var rot_args := [ [0.0, 2*PI], [2*PI, 0.0] ]
func reset_pos()->void:
	$ClockSect.position = anipos_list[0]
	$Calendar3d.position = anipos_list[1]
func start_move_animation():
	main_animation.start_move("clock",$ClockSect, anipos_list[0], anipos_list[1], 1)
	main_animation.start_rotate_subfield("clock",$ClockSect, Vector3.Axis.AXIS_Y, rot_args[0][0] , rot_args[0][1], 1)
	main_animation.start_move("clock",$Calendar3d, anipos_list[1], anipos_list[0], 1)
	main_animation.start_rotate_subfield("clock",$Calendar3d, Vector3.Axis.AXIS_Y, rot_args[1][0], rot_args[1][1], 1)
	anipos_list = [anipos_list[1], anipos_list[0]]
	rot_args = [rot_args[1], rot_args[0]]

func on_viewport_size_changed() -> void:
	var vp_size := get_viewport().get_visible_rect().size
	var 짧은길이 :float = min(vp_size.x, vp_size.y)
	var panel_size := Vector2(vp_size.x/2 - 짧은길이/2, vp_size.y)
	$"왼쪽패널".size = panel_size
	$"왼쪽패널".custom_minimum_size = panel_size
	$오른쪽패널.size = panel_size
	$"오른쪽패널".custom_minimum_size = panel_size
	$오른쪽패널.position = Vector2(vp_size.x/2 + 짧은길이/2, 0)

	$"왼쪽패널/LabelVersion".text = "%s %s" % [
			ProjectSettings.get_setting("application/config/name"),
			ProjectSettings.get_setting("application/config/version"),
			]
	var msg := ""
	for k in config:
		msg += "%s : %s\n" % [k, config[k] ]
	$"왼쪽패널/LabelConfig".text = msg

func label_demo() -> void:
	if $"오른쪽패널/LabelPerformance".visible:
		$"오른쪽패널/LabelPerformance".text = """%d FPS (%.2f mspf)
Currently rendering: occlusion culling:%s
%d objects
%dK primitive indices
%d draw calls""" % [
		Engine.get_frames_per_second(),1000.0 / Engine.get_frames_per_second(),
		get_tree().root.use_occlusion_culling,
		RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_TOTAL_OBJECTS_IN_FRAME),
		RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_TOTAL_PRIMITIVES_IN_FRAME) * 0.001,
		RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_TOTAL_DRAW_CALLS_IN_FRAME),
		]
	if $"오른쪽패널/LabelInfo".visible:
		$"오른쪽패널/LabelInfo".text = "%s" % [ MovingCameraLight.GetCurrentCamera() ]

var WorldSize := Vector3(160,90,80)
func _ready() -> void:
	on_viewport_size_changed()
	get_viewport().size_changed.connect(on_viewport_size_changed)
	_on_button_패널보이기_pressed()

	var sect_width = WorldSize.x/2
	anipos_list = [Vector3(-sect_width/2,0,0), Vector3(sect_width/2,0,0)]
	var depth = sect_width/20
	$ClockSect.init(sect_width/2, depth, sect_width*0.06, config, true)
	$Calendar3d.init(sect_width,sect_width,depth, sect_width*0.09, true)
	reset_pos()

	$FixedCameraLight.set_center_pos_far(Vector3.ZERO, Vector3(-1,0,sect_width),  WorldSize.length()*3)
	$MovingCameraLightHober.set_center_pos_far(Vector3.ZERO, Vector3(-1,0,sect_width),  WorldSize.length()*3)
	$MovingCameraLightAround.set_center_pos_far(Vector3.ZERO, Vector3(-1,0,sect_width),  WorldSize.length()*3)
	$FixedCameraLight.make_current()
	$AxisArrow3D.set_size(WorldSize.length()/10).set_colors()

func _notification(what: int) -> void:
	# app resume on android
	if what == NOTIFICATION_APPLICATION_RESUMED :
		pass

var old_minute_dict = Time.get_datetime_dict_from_system() # datetime dict
func _process(_delta: float) -> void:
	label_demo()
	rot_by_accel()
	main_animation.handle_animation()
	var now := Time.get_unix_time_from_system() /-3.0
	if $MovingCameraLightHober.is_current_camera():
		$MovingCameraLightHober.move_hober_around_z(now/2.3, Vector3.ZERO, WorldSize.length()/2, WorldSize.length()/4 )
	elif $MovingCameraLightAround.is_current_camera():
		$MovingCameraLightAround.move_wave_around_y(now/2.3, Vector3.ZERO, WorldSize.length()/2, WorldSize.length()/4 )

	var time_now_dict = Time.get_datetime_dict_from_system()
	if old_minute_dict["minute"] != time_now_dict["minute"]:
		old_minute_dict = time_now_dict
		start_move_animation()

var key2fn = {
	KEY_ESCAPE:_on_button_esc_pressed,
	KEY_ENTER:_on_카메라변경_pressed,
	KEY_PAGEUP:_on_button_fov_up_pressed,
	KEY_PAGEDOWN:_on_button_fov_down_pressed,

	KEY_TAB : _on_button_패널보이기_pressed,
	KEY_SPACE : _on_button_패널보이기_pressed,
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
	MovingCameraLight.GetCurrentCamera().camera_fov_inc()

func _on_button_fov_down_pressed() -> void:
	MovingCameraLight.GetCurrentCamera().camera_fov_dec()

func _on_button_패널보이기_pressed() -> void:
	패널보이기(true)
	$"Timer패널숨기기".start(3)

func _on_timer패널숨기기_timeout() -> void:
	패널보이기(false)

func 패널보이기(b :bool) -> void:
	$"왼쪽패널".visible = b
	$"오른쪽패널".visible = b

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
