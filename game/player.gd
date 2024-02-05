extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -400.0
var doubleJumped = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if !is_on_floor():
		velocity.y += gravity * delta
	else:
		doubleJumped = 1

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Double jump
	elif Input.is_action_just_pressed("jump") and !is_on_floor() and doubleJumped != 0:
		velocity.y = JUMP_VELOCITY
		doubleJumped = 0
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("moveLeft", "moveRight")
	if direction:
		if abs(velocity.x) <= SPEED:
			velocity.x += (SPEED / 20) * direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
