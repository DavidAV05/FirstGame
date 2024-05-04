extends State

func enter():
	# Iets met uiterlijk, komt later
	pass

func exit():
# Iets met uiterlijk, komt later
	pass

func _on_hitbox_body_entered(body):
	if body.name == "player":
		Transition.emit(self, "Depollenised")
