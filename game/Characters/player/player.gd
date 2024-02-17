extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -500.0

# Dash variables
var dash = true
@onready var dash_timer = $dash_timer
# * See wait time in _ready
const dash_cooldown = .5

# Jump variables
@onready var coyote_timer = $coyote_timer
var can_jump = true

# Gets all the camera variables
@onready var camera = $Camera2D
@onready var camera_lag = camera.position_smoothing_enabled
@onready var camera_lag_speed = camera.position_smoothing_speed

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var TERMINAL_VELOCITY = gravity * 3

func _ready():
	coyote_timer.wait_time = 1

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

# Handles jump input, check next to gravity for coyote timer
func jump_func():
	if can_jump:
		can_jump = false
		velocity.y = JUMP_VELOCITY

# Handles coyote timer
func _on_coyote_timer_timeout():
	can_jump = false

func _physics_process(delta):
	move_and_slide()
	print("Timer stopped: ", coyote_timer.is_stopped())
	print("Can jump: ", can_jump)
	

	# Add the gravity and dash "recharge".
	if !is_on_floor() and velocity.y <= TERMINAL_VELOCITY:
		# Gravity
		velocity.y += gravity * delta
		
		if coyote_timer.is_stopped():
			coyote_timer.start()
	else:
		coyote_timer.stop()
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
