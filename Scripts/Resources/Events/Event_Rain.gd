extends Event

@export var rain_particles : GPUParticles2D
@export var rain_audio : AudioStreamPlayer

func start() -> void:
	_start_timer()
	rain_particles.emitting = true
	_start_rain_audio()
	event_started.emit(self)

func end() -> void:
	rain_particles.emitting = false
	await _end_rain_audio()
	event_finished.emit(self)

func _start_rain_audio() -> void:
	var tween = get_tree().create_tween()
	rain_audio.playing = true
	tween.tween_property(rain_audio, ^"volume_db", 0.0, 5).from(-20.0)

func _end_rain_audio() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(rain_audio, ^"volume_db", -20.0, 2).from_current()
	await tween.finished
	rain_audio.playing = false
