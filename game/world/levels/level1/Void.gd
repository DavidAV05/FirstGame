extends Area2D

@onready var player = $"../../player"

func _process(_delta):
	self.position.x = player.position.x



func _on_body_entered(body):
	if body.name == "player":
		var start_position: Vector2 = Vector2(0, 0)
		player.death(start_position)
