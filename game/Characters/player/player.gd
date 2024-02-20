extends CharacterBody2D

@export var SPEED := 200.0
@export var JUMP_VELOCITY := -500.0
@export var WALL_CLIMB_SPEED := 200.0

# Global variables
var dash: bool = true
var climb_dir: int = 1

# Coyote variables
@onready var Coyote_Jump = %CoyoteJump

# Dash variables
@onready var dash_timer = %DashTimer
@export var DASH_COOLDOWN = .5

# Gets all the camera variables
@onready var camera = %Camera2D
@onready var camera_lag = camera.position_smoothing_enabled
@onready var camera_lag_speed = camera.position_smoothing_speed

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var TERMINAL_VELOCITY = gravity * 3

func gravity_func(delta: float, on_floor: bool, on_wall: bool) -> void:
	# When going upwards gravity:
	if !on_floor and !on_wall and velocity.y <= 0:
		velocity.y += gravity * delta
	# When going downwards gravity:
	elif !on_floor and !on_wall and velocity.y < TERMINAL_VELOCITY:
		velocity.y += gravity * delta * 1.35



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
func wall_climb_func(delta: float, on_floor: bool) -> void:
	# When walking against wall, start climbing
	if on_floor:
		climb_dir = -1
		velocity.y -= float(WALL_CLIMB_SPEED) / 3
	
	# -1 is upwards, 1 is downwards
	if Input.is_action_pressed("move_down") or Input.is_action_pressed("move_up"):
		climb_dir = int(Input.get_axis("move_up", "move_down"))

	var move_to: float = WALL_CLIMB_SPEED * climb_dir
#
	if abs(velocity.y) > abs(WALL_CLIMB_SPEED):
		velocity.y = move_toward(velocity.y, move_to, WALL_CLIMB_SPEED * delta * 18)
	else:
		velocity.y = move_toward(velocity.y, move_to, WALL_CLIMB_SPEED * delta * 6)



# Handles all the dash abilities
func dash_func	(direction: int, on_floor: int) -> void:
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
	var on_wall = is_on_wall()

	# Handles gravity
	gravity_func(delta, on_floor, on_wall)
	
	# Handles coyote timer
	Coyote_Jump.can_jump_handler(on_floor)
	
	# Gets direction
	var direction = Input.get_axis("move_left", "move_right")

	# Handle the horizontal movement/deceleration.
	move_horizontal(direction)

	#Handle jump.
	if Input.is_action_pressed("jump"):
		jump_func(Coyote_Jump.get_can_jump())
	
	if !on_wall:
		if velocity.y > 0:
			climb_dir = 1
		else:
			climb_dir = -1
	if on_wall:
		wall_climb_func(delta, on_floor)

	# Handles dashing
	if Input.is_action_pressed("dash"):
		dash_func(direction, on_floor)
	
	move_and_slide()

func death(start_position: Vector2) -> void:
	# Disable camera lag and velocity.
	camera_lag = false
	velocity = Vector2(0, 0)
	
	# Teleport player to given start_position.
	self.position = start_position
	
	# Enable camera lag again.
	camera_lag_speed = true
