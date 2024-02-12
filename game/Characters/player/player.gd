extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -700.0

var dash = true
@onready var dash_timer = $dash_timer
const dash_cooldown = .5

# Gets all the camera variables
@onready var camera = $Camera2D
@onready var camera_lag = camera.position_smoothing_enabled
@onready var camera_lag_speed = camera.position_smoothing_speed

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var TERMINAL_VELOCITY = gravity * 3

# Handles all the basic horizontal movement
func move_horizontal (direction):
	# Checks if player is walking
	velocity.x = move_toward(velocity.x, SPEED * direction, SPEED / 10)



# Handles all the dash abilities
func dash_func(direction):
	# Checks if dashing is not activated
	if dash_timer.is_stopped():
		# Starts timer
		dash_timer.wait_time = dash_cooldown
		dash_timer.start()
		# Define dash up
		if Input.is_action_pressed("move_up"):
			velocity.y = JUMP_VELOCITY * 1.5
		# Define dash down
		elif Input.is_action_pressed("move_down"):
			velocity.y = -JUMP_VELOCITY * 1.5
		# Define dash right and left
		else:
			velocity.x = SPEED * 3 * direction

	dash = false



func _physics_process(delta):
	move_and_slide()

	# Add the gravity and dash "recharge".
	if !is_on_floor() and velocity.y <= TERMINAL_VELOCITY:
		velocity.y += gravity * delta
	else:
		dash = true

	# Gets direction
	var direction = Input.get_axis("move_left", "move_right")

	# Handle the horizontal movement/deceleration.
	move_horizontal(direction)
		
	# Handles dashing
	if Input.is_action_just_pressed("dash") and dash == true:
		dash_func(direction)

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY



func death(start_position : Vector2):
	# Disable camera lag and velocity.
	camera_lag = false
	velocity = Vector2(0, 0)
	
	# Teleport player to given start_position.
	self.position = start_position
	
	# Enable camera lag again.
	camera_lag_speed = true

