extends Node

const SAVE_PATH : String = "user://config.cfg"

var config : ConfigFile = null

signal loaded_settings()

func _enter_tree() -> void:
	_load_settings()


func _load_settings() -> void:
	config = ConfigFile.new()

	# Load data from a file.
	var err = config.load(SAVE_PATH)

	# If the file didn't load, ignore it.
	if err != OK:
		push_warning("The save file couldn't be loaded, creating default save")
		save_settings()
		loaded_settings.emit()
		return
	
	loaded_settings.emit()


func save_settings() -> void:
	# Create new ConfigFile object.
	var new_config = ConfigFile.new()

	var master_volume : float = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(&"Master")))
	var slugcat_volume : float = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(&"Slugcat")))
	var rain_volume : float = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(&"Rain")))
	
	new_config.set_value("Volume", "master_volume", master_volume)
	new_config.set_value("Volume", "slugcat_volume", slugcat_volume)
	new_config.set_value("Volume", "rain_volume", rain_volume)

	# Save it to a file (overwrite if already exists).
	new_config.save(SAVE_PATH)
	config = new_config
