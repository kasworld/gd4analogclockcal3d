extends Node3D

func _ready() -> void:
	$DirectionalLight3D.look_at(Vector3.ZERO)
	$Camera3D.look_at(Vector3.ZERO)
	$AnalogClock3d.init(36)

func _process(delta: float) -> void:
	var t = Time.get_unix_time_from_system() /-3.0
	$Camera3D.position = Vector3(sin(t)*40 ,70.0, cos(t)*40  )
	$Camera3D.look_at(Vector3.ZERO)
