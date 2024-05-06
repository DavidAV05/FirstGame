extends Node


signal Pollen_Add

# Called when the node enters the scene tree for the first time.
func _ready():
	var scene := get_tree()
	for child in scene.get_children():
		if child is Interactable:
			child.transitioned.connect(child.signal_inventory())

func on_pollen_adding(n_pollen: int):
	Pollen_Add.emit(n_pollen)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
