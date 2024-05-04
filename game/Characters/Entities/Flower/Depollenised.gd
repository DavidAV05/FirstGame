extends State

@export var MINIMAL_WAIT := 10

var RNG = RandomNumberGenerator.new()
var CURRENT_STATE := false
@onready var TIMER : Timer = %PolleniseTimer

func enter():
	# Iets met uiterlijk, komt later
	CURRENT_STATE = true
	var wait_time = MINIMAL_WAIT + int(RNG.randf_range(0, MINIMAL_WAIT / 2))
	TIMER.wait_time = wait_time
	TIMER.start()

func exit():
	# Iets met uiterlijk, komt later
	CURRENT_STATE = false
	pass

func _on_pollenise_timer_timeout():
	if CURRENT_STATE:
		Transition.emit(self, "Pollenised")
