extends Control

@export var config_panel : PanelContainer
@export var config_button : Button


func _on_config_button_pressed() -> void:
	config_panel.visible = !config_panel.visible

func _on_config_button_mouse_entered() -> void:
	config_button.modulate = Color(1,1,1, 0.8)


func _on_config_button_mouse_exited() -> void:
	config_button.modulate = Color(1,1,1,0)
