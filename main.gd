extends Node3D

const sect_width :float = 34*2

func _ready() -> void:
	RenderingServer.set_default_clear_color( Global3d.colors.default_clear)
	reset_camera_pos()

	$DirectionalLight3D.look_at(Vector3.ZERO)

	$AnalogClock3d.init(sect_width/2)
	$AnalogClock3d.position.z = sect_width/2

	$Calendar3d.init(sect_width,sect_width)
	$Calendar3d.position.z = -sect_width/2


func reset_camera_pos()->void:
	$Camera3D.position = Vector3(-1,sect_width/1.35,0)
	$Camera3D.look_at(Vector3.ZERO)

var camera_move = false
func _process(delta: float) -> void:
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
