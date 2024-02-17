extends CharacterBody2D

@export var SPEED = 200.0
@export var JUMP_VELOCITY = -500.0
@export var WALL_SLIDE_SPEED = 100

# Dash variables
var dash = true
@onready var dash_timer = $dash_timer
@export var DASH_COOLDOWN = .5

# Jump variables
@onready var coyote_timer = $coyote_timer
@export var COYOTE_COOLDOWN = .1
var can_jump = true

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
		dash_timer.wait_time = DASH_COOLDOWN
		dash_timer.start()
		# Define dash up
		if Input.is_action_pressed("move_up"):
			velocity.y = JUMP_VELOCITY * 1.5
		# Define dash down
		elif Input.is_action_pressed("move_down"):
			velocity.y = -JUMP_VELOCITY * 1.5
		# Define dash right and left
		else:
			velocity.y = JUMP_VELOCITY * 0.75
			velocity.x = SPEED * 3 * direction

	dash = false

# Handles jump input, check next to gravity for coyote timer
func jump_func():
	if can_jump:
		can_jump = false
		velocity.y = JUMP_VELOCITY

# Handles coyote timer
func _on_coyote_timer_timeout():
	print("Timed out")
	can_jump = false

func _physics_process(delta):
	move_and_slide()
	

	# Add the gravity and dash "recharge".
	if !is_on_floor() and velocity.y <= TERMINAL_VELOCITY:
		# Gravity
		if velocity.y < 0 and !is_on_wall():
			velocity.y += gravity * delta
		elif is_on_wall() and velocity.y > 0:
			velocity.y = move_toward(velocity.y, WALL_SLIDE_SPEED, abs(delta * velocity.y * 5))
		else:
			velocity.y += gravity * delta * 1.5
		
		if coyote_timer.is_stopped():
			coyote_timer.start()
	else:
		coyote_timer.stop()
		coyote_timer.wait_time = COYOTE_COOLDOWN
		can_jump = true
		dash = true


	# Gets direction
	var direction = Input.get_axis("move_left", "move_right")

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		jump_func()

	# Handle the horizontal movement/deceleration.
	move_horizontal(direction)
		
	# Handles dashing
	if Input.is_action_just_pressed("dash") and dash == true:
		dash_func(direction)




func death(start_position: Vector2):
	# Disable camera lag and velocity.
	camera_lag = false
	velocity = Vector2(0, 0)
	
	# Teleport player to given start_position.
	self.position = start_position
	
	# Enable camera lag again.
	camera_lag_speed = true
