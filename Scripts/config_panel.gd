extends PanelContainer

@export var master_vol_slider : HSlider
@export var slug_vol_slider : HSlider
@export var rain_vol_slider : HSlider

@onready var master_audio_idx : int = AudioServer.get_bus_index(&"Master")
@onready var slug_audio_idx : int = AudioServer.get_bus_index(&"Slugcat")
@onready var rain_audio_idx : int = AudioServer.get_bus_index(&"Rain")

func _ready() -> void:
	if GlobalSettings.config == null:
		await GlobalSettings.loaded_settings
	load_settings()


func _on_close_button_pressed() -> void:
	save_settings()
	visible = false


func load_settings() -> void:
	master_vol_slider.value = GlobalSettings.config.get_value("Volume", "master_volume")
	slug_vol_slider.value = GlobalSettings.config.get_value("Volume", "slugcat_volume")
	rain_vol_slider.value = GlobalSettings.config.get_value("Volume", "rain_volume")
	
	AudioServer.set_bus_volume_db(master_audio_idx, linear_to_db(master_vol_slider.value))
	AudioServer.set_bus_volume_db(slug_audio_idx, linear_to_db(slug_vol_slider.value))
	AudioServer.set_bus_volume_db(rain_audio_idx, linear_to_db(rain_vol_slider.value))
	
func save_settings() -> void:
	GlobalSettings.save_settings()

func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_audio_idx, linear_to_db(value))

func _on_slug_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(slug_audio_idx, linear_to_db(value))

func _on_rain_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(rain_audio_idx, linear_to_db(value))
