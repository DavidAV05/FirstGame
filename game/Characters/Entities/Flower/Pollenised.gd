extends State

signal Pollen_Add

func enter():
	# Iets met uiterlijk, komt later
	pass

func exit():
# Iets met uiterlijk, komt later
	pass

func _on_hitbox_body_entered(body : Player):
	if body is Player:
		body.inventory.add_pollen(1)
		Pollen_Add.emit(body.name)
		Transition.emit(self, "Depollenised")
