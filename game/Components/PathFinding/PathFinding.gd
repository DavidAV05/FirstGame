extends Node2D
class_name PathFinding

# Set via parent script.

@export var target : Node2D
@export var parent : Node2D
@export var refresh_rate : float

@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D
@onready var timer : Timer = $RefreshRate

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_target_position()
	timer.wait_time = refresh_rate


func get_direction() -> Vector2:
	var target_pos := nav_agent.get_next_path_position()
	var direction = target_pos - parent.global_position
	return direction.normalized()


func change_target(new_target : Node2D) -> void:
	target = new_target
	_set_target_position()

func get_nav_agent() -> NavigationAgent2D:
	return nav_agent


func _set_target_position() -> void:
	if target:
		nav_agent.target_position = target.global_position
	else:
		print('No target defined.')


func _on_refresh_rate_timeout():
	_set_target_position()
