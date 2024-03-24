extends Control

func _ready() -> void:
	update_label_info()

func update_label_info()->void:
	$LabelInfo.text = """%d FPS (%.2f mspf)""" % [
	Engine.get_frames_per_second(),
	1000.0 / Engine.get_frames_per_second(),
]

func _on_timer_timeout() -> void:
	update_label_info()
