extends CharacterBody2D

@export var SPEED = 200.0
@export var JUMP_VELOCITY = -500.0
@export var WALL_CLIMB_SPEED = 300

# Dash variables
@onready var dash_timer = $DashTimer
@export var DASH_COOLDOWN = .5

# Coyote variables
@onready var Coyote_Jump = $CoyoteJump

# Gets all the camera variables
@onready var camera = $Camera2D
@onready var camera_lag = camera.position_smoothing_enabled
@onready var camera_lag_speed = camera.position_smoothing_speed

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var TERMINAL_VELOCITY = gravity * 3

func gravity_func(delta: float, on_floor: bool, on_wall: bool) -> void:
	if !on_floor and !on_wall and velocity.y <= 0:
		velocity.y += gravity * delta
	elif !on_floor and !on_wall and velocity.y < TERMINAL_VELOCITY:
		velocity.y += gravity * delta * 1.25

# Handles all the basic horizontal movement
func move_horizontal(direction: int) -> void:
	# Checks if player is walking
	velocity.x = move_toward(velocity.x, SPEED * direction, SPEED / 10)

# Handles jump input, check next to gravity for coyote timer
func jump_func(can_jump: bool) -> void:
	if can_jump:
		can_jump = false
		velocity.y = JUMP_VELOCITY

# Handles the wall sliding of character.
func wall_slide_func(delta: float, on_floor: bool, on_wall: bool) -> void:
	var direction := 0
	var climbing := 1
	if velocity.y >= 0:
		direction = 1
	else:
		direction = -1	
	
	if  Input.is_action_pressed("jump"):
		direction = 0
		climbing = 1.5

	if on_wall:
		print(WALL_CLIMB_SPEED * direction)
		print(WALL_CLIMB_SPEED * delta * .5)
		velocity.y = move_toward(velocity.y,
			WALL_CLIMB_SPEED * direction, 
			WALL_CLIMB_SPEED * delta * 2 * climbing)

# Handles all the dash abilities
func dash_func	(dash: bool, direction: int, on_floor: int) -> void:
	if on_floor:
		dash = true
	# Checks if dashing is not activated
	if dash_timer.is_stopped() and dash == true:
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

func _physics_process(delta):
	var on_floor = is_on_floor()
	var on_wall = is_on_wall_only()
	var dash: bool = true;

	# Handles gravity
	gravity_func(delta, on_floor, on_wall)
	
	# Handles coyote timer
	Coyote_Jump.can_jump_handler(on_floor)
	
	# Gets direction
	var direction = Input.get_axis("move_left", "move_right")

	# Handle the horizontal movement/deceleration.
	move_horizontal(direction)

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		jump_func(Coyote_Jump.get_can_jump())
	
	wall_slide_func(delta, on_floor, on_wall)

	# Handles dashing
	if Input.is_action_just_pressed("dash"):
		dash_func(dash, direction, on_floor)
	
	move_and_slide()

func death(start_position: Vector2) -> void:
	# Disable camera lag and velocity.
	camera_lag = false
	velocity = Vector2(0, 0)
	
	# Teleport player to given start_position.
	self.position = start_position
	
	# Enable camera lag again.
	camera_lag_speed = true
