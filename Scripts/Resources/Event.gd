extends Node
class_name Event

@export_range(0, 120, 1.0, "or_greater", "suffix:seconds") var min_duration
@export_range(0, 120, 1.0, "or_greater", "suffix:seconds") var max_duration

signal event_started(event : Event)
signal event_finished(event : Event)

@onready var timer : Timer

func _enter_tree() -> void:
	timer = Timer.new()
	timer.autostart = false
	timer.one_shot = true
	self.add_child(timer)

func start() -> void:
	_start_timer()
	event_started.emit(self)

func end() -> void:
	event_finished.emit(self)

func _start_timer() -> void:
	if not timer.timeout.is_connected(end):
		timer.timeout.connect(end)
	timer.start(randi_range(min_duration, max_duration))
