extends StateMachineState

@onready var slugcat : Slugcat = get_state_machine().get_parent()

@export var min_time : float = 3
@export var max_time : float = 8

@export var walking_particles : GPUParticles2D
@onready var waiting_timer: Timer = $WaitingTimer

# Called when the state machine enters this state.
func _enter_state() -> void:
	if started == true: return
	started = true
	
	var leader : Slugcat = slugcat.slugcat_data.leader
	if leader == null:
		get_state_machine().set_next_state("Walking")
	
	
	var mov_time : float = randf_range(min_time, max_time) * SlugcatData.get_trait_multiplier(slugcat.slugcat_data.loving)
	var new_pos : Vector2 = leader.global_position
	
	mov_time = max(mov_time, min_time)
	
	waiting_timer.start(mov_time)
	walking_particles.speed_scale = mov_time / max_time
	walking_particles.rotation_degrees = 180 if new_pos.x >= slugcat.global_position.x else 0
	walking_particles.emitting = true
	go_to_mama()

# Called when the state machine exits this state.
func _exit_state() -> void:
	started = false
	walking_particles.emitting = false

func go_to_mama() -> void:
	var tween : Tween = create_tween()
	var leader : Slugcat = slugcat.slugcat_data.leader
	var new_pos : Vector2 = Wanderzone.get_point_near_point(leader.global_position, 10, 50 - (slugcat.slugcat_data.loving * 10)) 
	
	slugcat.sprite.flip_h = new_pos.x >= slugcat.global_position.x
	slugcat.sprite.sprite_frames = slugcat.slugcat_data.type.animation_walking
	slugcat.sprite.play("default")
	slugcat.sprite.speed_scale = SlugcatData.get_trait_multiplier(slugcat.slugcat_data.energic)
	
	tween.tween_property(
		slugcat, 
		"global_position", 
		new_pos, 
		SlugcatData.get_trait_multiplier(slugcat.slugcat_data.energic)
	).from_current()\
	.set_ease(Tween.EASE_OUT_IN)
	await tween.finished
	
	
	if  not waiting_timer.is_stopped() or \
		leader.state_machine.get_current_state().name == "Walking":
		go_to_mama()
	else:
		if randi_range(0, 10) <= slugcat.slugcat_data.loving:
			get_state_machine().set_next_state("Needing")
		else:
			get_state_machine().set_next_state("Idling")


## Returns the state machine node.
## Generates an error and returns [code]null[/code] if this node is not a child of a [StateMachine] node.
func get_state_machine() -> StateMachine:
	if get_parent() is not StateMachine:
		push_error("State node must be a child of a state machine node")
	return get_parent() as StateMachine


## Checks if this state is the current state.
func is_current_state() -> bool:
	var state_machine := get_state_machine()
	return is_instance_valid(state_machine) and state_machine.current_state == self


# Customizes the behaviour of 'set'.
func _set(property: StringName, value: Variant) -> bool:
	# Call the '_enter_state' or '_exit_state' functions when the node is enabled or disabled
	if property == &"process_mode":
		# Enter the state if the node is being enabled
		if value == Node.PROCESS_MODE_INHERIT:
			# The node cannot be enabled without setting it as the current state
			if not is_current_state():
				push_error("Cannot enable node because it is not the current state")
				return true
			# Enter the state
			_enter_state()
			state_entered.emit()
		# Exit the state if the node is being disabled
		elif value == Node.PROCESS_MODE_DISABLED:
			# Do nothing if the state is not current to allow the node to be disabled from the state machine's '_ready' function
			if is_current_state():
				# Exit the state
				_exit_state()
				state_exited.emit()
		# Process mode for state nodes should either be 'inherit' or 'disabled'
		else:
			push_error("Process mode for state nodes should either be 'inherit' or 'disabled'. For a different behaviour, change the process mode of the state machine node.")
			return true
	# The property should be handled normally
	return false
