extends Node3D

func _ready() -> void:
	$DirectionalLight3D.look_at(Vector3.ZERO)
	$Camera3D.look_at(Vector3.ZERO)
	$AnalogClock3d.init(36)
	$Calendar3d.init(36,36)

var camera_move = false
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
			pass

	elif event is InputEventMouseButton and event.is_pressed():
		pass
