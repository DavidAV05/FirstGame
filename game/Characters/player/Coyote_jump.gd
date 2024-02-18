extends Node2D

var can_jump: bool = false;
@onready var coyote_timer = $CoyoteTimer
@export var COYOTE_COOLDOWN := .1

func get_can_jump() -> bool:
	return can_jump

# Handles coyote timer
func can_jump_handler(on_floor: bool) -> bool:
	# When leaving ground start the timer
	if !on_floor and coyote_timer.is_stopped():
		coyote_timer.start()
	# When back on the floor set jumping to true
	elif on_floor:
		coyote_timer.stop()
		coyote_timer.wait_time = COYOTE_COOLDOWN
		can_jump = true

	return can_jump

# Handles coyote timer
func _on_coyote_timer_timeout():
	can_jump = false
