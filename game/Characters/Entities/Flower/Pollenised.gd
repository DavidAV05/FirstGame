extends State

var current_state := false

func enter():
	# Iets met uiterlijk, komt later
	current_state = true
	pass

func exit():
# Iets met uiterlijk, komt later
	current_state = false
	pass

func update(_delta):
	print("Wzp, pollenised here\n\n\n\n")

func _on_hitbox_body_entered(body : Player):
	if body is Player and current_state == true:
		body.inventory.add_pollen(1)
		Transition.emit(self, "Depollenised")
