extends Node2D
class_name Inventory

var _TOTAL_POLLEN : int = 0 

func _ready():
	print(get_tree())

func add_pollen(n_pollen: int) -> void:
	_TOTAL_POLLEN += n_pollen 

func remove_pollen(n_pollen: int) -> void:
	_TOTAL_POLLEN -= n_pollen

func get_total_pollen() -> int:
	return _TOTAL_POLLEN
