class_name Config

func file_full_path(name :String)->String:
	return OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/" + name

func file_exist(name :String)->bool:
	return FileAccess.file_exists(file_full_path(name))

func save_json(name :String, config :Dictionary)-> String:
	config.erase("load_error") # remove old load result
	var fileobj = FileAccess.open( file_full_path(name), FileAccess.WRITE)
	var json_string = JSON.stringify(config)
	fileobj.store_line(json_string)
	return "%s save" % [file_full_path(name)]

func new_by_load(name :String, config :Dictionary, version_key:String)->Dictionary:
	config.erase("load_error") # remove old load result
	var rtn = {}
	var fileobj = FileAccess.open(file_full_path(name), FileAccess.READ)
	var json_string = fileobj.get_as_text()
	var json = JSON.new()
	var error = json.parse(json_string)
	if error == OK:
		rtn.config = json.data
		for k in config:
			if rtn.config.get(k) == null :
				rtn.load_error = "field not found %s" % [ k ]
				break
		if rtn.load_error.is_empty() and ( rtn.config[version_key] != config[version_key] ):
			rtn.load_error = "version not match %s %s" % [rtn.config[version_key] , config[version_key]]
	else:
		rtn.load_error = "JSON Parse Error: %s in %s at line %s" % [ json.get_error_message(),  json_string,  json.get_error_line()]
	return rtn
