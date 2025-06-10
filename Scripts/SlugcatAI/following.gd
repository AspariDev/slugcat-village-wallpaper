extends StateMachineState


# Called when the state machine enters this state.
func _enter_state() -> void:
	if started == true: return
	started = true


# Called when the state machine exits this state.
func _exit_state() -> void:
	started = false


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
