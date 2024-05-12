extends Node2D
class_name Health

@export var MAX_HEALTH : float
var _health : float

# Called when the node enters the scene tree for the first time.
func _ready():
	_health = MAX_HEALTH


func damage(HP : float) -> void:
	_health -= HP


func heal(HP : float) -> void:
	_health += HP


func get_health() -> float:
	return _health
