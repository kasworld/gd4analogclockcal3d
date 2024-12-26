extends PanelContainer

signal config_changed(cfg :Dictionary)
signal config_reset_req()

var lineedit_dict = {}

func init(filename:String, config:Dictionary, editable_keys:Array, rt :Rect2)->void:

	size = rt.size
	position = rt.position
	theme.default_font_size = int(rt.size.y / 10.0)

	# make label, lineedit
	for k in editable_keys:
		var lb = Label.new()
		lb.text = k
		$VBoxContainer/GridContainer.add_child(lb)
		var le = LineEdit.new()
		le.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		le.text = config[k]
		lineedit_dict[k]= le
		$VBoxContainer/GridContainer.add_child(le)

	config_to_control(filename,config,editable_keys)

func config_to_control(filename:String, config:Dictionary, editable_keys:Array)->void:
	$VBoxContainer/ConfigLabel.text =Config.file_full_path(filename)
	$VBoxContainer/VersionLabel.text = config.version
	for k in editable_keys:
		lineedit_dict[k].text = config[k]

func _on_button_ok_pressed() -> void:
	hide()
	var cfg :Dictionary = {}
	for k in lineedit_dict:
		cfg[k] = lineedit_dict[k].text
	config_changed.emit(cfg)

func _on_button_cancel_pressed() -> void:
	hide()

func _on_button_reset_pressed() -> void:
	config_reset_req.emit()
