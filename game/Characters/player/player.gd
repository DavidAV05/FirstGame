extends CharacterBody2D

@export var SPEED := 1000.0
@export var MAX_SPEED := 500
@export var FRICTION_SPEED := 2

# Gets all the camera variables
@onready var camera = %Camera2D
@onready var camera_lag = camera.position_smoothing_enabled
@onready var camera_lag_speed = camera.position_smoothing_speed

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var TERMINAL_VELOCITY = gravity * 3


func basic_movement(delta: float) -> void:
	var direction_x = Input.get_axis("move_left", "move_right")
	var direction_y = Input.get_axis("move_up", "move_down")
	var direction = Vector2(direction_x, direction_y)
	direction = direction.normalized()

	var movement = direction * (SPEED * delta)

	velocity += movement

	if velocity.x < 0:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false


func friction(delta: float) -> void:
	var direction := velocity.normalized()
	var friction := (direction * velocity.length() * delta) / 0.3
	velocity -= friction
	print(friction)


func _physics_process(delta: float) -> void:
	# Defining max speed
	velocity = velocity.limit_length(MAX_SPEED)

	if Input.is_action_pressed("move"):
		basic_movement(delta)
	
	friction(delta)

	move_and_slide()


func death(start_position: Vector2) -> void:
	# Disable camera lag and velocity.
	camera_lag = false
	velocity = Vector2(0, 0)
	
	# Teleport player to given start_position.
	self.position = start_position
	
	# Enable camera lag again.
	camera_lag_speed = true
