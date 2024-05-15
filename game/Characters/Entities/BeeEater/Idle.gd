extends State

@export var ANCESTOR : MovingEntity
@onready var timer : Timer = $WanderTime

func update(_delta):
	pass

func enter():
	timer.start()

func exit():
	pass



func _on_wander_time_timeout():
	var new_position = ANCESTOR.global_position + Vector2(randi() % 10, randi() % 10)
	move_to(ANCESTOR, new_position)
	timer.start()
