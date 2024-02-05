extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var chasing = false
var player = null


func _physics_process(delta):
	var direction = 0
	move_and_slide()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if chasing:
		if player.position.x - self.position.x < -10:
			direction = -1
		elif player.position.x - self.position.x > 10:
			direction = 1
		else:
			direction = 0
		print(direction)
			
		velocity.x = SPEED * direction


func _on_player_detection_body_entered(body):
	if body.name == "player":
		chasing = true
		player = body


func _on_player_chase_area_body_exited(body):
	if body.name == "player":
		chasing = false


func _on_lethal_collision_body_entered(body):
	if body.name == "player":
		body.death(Vector2(0, 0))
