@tool
@icon("res://Assets/ClassIcons/Survivor_icon_(custom).webp")
extends Node2D
class_name Slugcat

@onready var sprite: AnimatedSprite2D = $Visual/Sprite
@onready var exclamation: Sprite2D = $Visual/Exclamation

@onready var wah_stream_player: AudioStreamPlayer2D = $WahStreamPlayer

@export var slugcat_data : SlugcatData :
	set(new_value):
		slugcat_data = new_value
		if slugcat_data != null:
			body_color = slugcat_data.body_color
			eyes_color = slugcat_data.eyes_color
		_update_color()

@export_color_no_alpha var body_color : Color = Color.WHITE :
	set(new_value):
		body_color = new_value
		if slugcat_data != null:
			slugcat_data.body_color = body_color
		_update_color()

@export_color_no_alpha var eyes_color : Color = Color.BLACK :
	set(new_value):
		eyes_color = new_value
		if slugcat_data != null:
			slugcat_data.eyes_color = eyes_color
		_update_color()

@export var slugpup_texture : Texture2D

@export var wander_zone : Wanderzone

@export var starting_state : StateMachineState
@onready var state_machine: StateMachine = $StateMachine

func _enter_tree() -> void:
	visible = false
	await get_tree().process_frame
	_update_color()
	if slugcat_data != null:
		body_color = slugcat_data.body_color
		eyes_color = slugcat_data.eyes_color
	visible = true
	state_machine.set_current_state(starting_state)

func _update_color() -> void:
	if sprite == null: return
	var palette : PackedColorArray = [body_color, eyes_color]
	sprite.material.set("shader_parameter/output_palette_array", palette)

func wah() -> void:
	wah_stream_player.stream = slugcat_data.type.sounds.pick_random()
	wah_stream_player.play()
