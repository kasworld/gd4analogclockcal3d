extends Node3D

func _ready() -> void:
	$DirectionalLight3D.look_at(Vector3.ZERO)
	$Camera3D.look_at(Vector3.ZERO)
