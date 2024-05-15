extends Node2D
class_name StateMachine

@export var INITIAL_STATE : State

var states : Dictionary = {}

var CURRENT_STATE : State

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in self.get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transition.connect(on_child_transition)
	
	if INITIAL_STATE:
		INITIAL_STATE.enter()
		CURRENT_STATE = INITIAL_STATE	


func _process(delta):
	print("Wazzup, state machine here.")
	for state in states:
		print("States ", state)
	if CURRENT_STATE:
		print(CURRENT_STATE.name)
		CURRENT_STATE.update(delta)


func on_child_transition(old_state, new_state_name):
	if old_state != CURRENT_STATE:
		printerr("States out of sync")
		return
	
	var new_state = states[new_state_name.to_lower()]
	if !new_state:
		printerr("Tried transitioning to non-existing state")
		return
	
	if CURRENT_STATE:
		CURRENT_STATE.exit()
	
	new_state.enter()
	
	CURRENT_STATE = new_state
