extends Node
class_name EventSystem

@export var possible_events : Array[Event]
@export_range(0, 600, 1.0, "or_greater", "suffix:seconds") var min_cooldown
@export_range(0, 600, 1.0, "or_greater", "suffix:seconds") var max_cooldown

@onready var timer : Timer

func _enter_tree() -> void:
	timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(start_event)
	add_child(timer)
	timer.start(randi_range(min_cooldown, max_cooldown))


func start_event() -> void:
	var new_event : Event = possible_events.pick_random()
	new_event.start()
	if not new_event.event_finished.is_connected(restart):
		new_event.event_finished.connect(restart)

func restart() -> void:
	timer.start(randi_range(min_cooldown, max_cooldown))
