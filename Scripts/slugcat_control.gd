extends Control

@onready var visual: Node2D = $"../Visual"

@export var slugcat: Slugcat
@export var love_particles_scene : PackedScene

func _on_waa_button_pressed() -> void:
	if slugcat.state_machine.get_current_state().name == "Needing":
		_spawn_love()
	slugcat.wah()

func _spawn_love() -> void:
	var new_love : GPUParticles2D = love_particles_scene.instantiate()
	visual.add_child(new_love)
	new_love.emitting = true
	new_love.material.set("shader_parameter/output_palette_array", [slugcat.body_color, slugcat.eyes_color])
	await new_love.finished
	new_love.queue_free()
