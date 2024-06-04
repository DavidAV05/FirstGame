extends CharacterBody2D
class_name Player

@onready var ANIM: AnimatedSprite2D = $AnimatedSprite2D

@export var SPEED: float = 20.0
@export var MAX_SPEED: float = 100.0
@export_range(0, 1) var DRAG: float = 0.8
@export var JUMP_VELOCITY: float = -400.0

var Y_FACING := "south"
var X_FACING := "east"

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	ANIM.play("IdleSE")

func _physics_process(_delta):
	var local_max = MAX_SPEED
	# Sprinting
	if Input.is_action_pressed("sprint"):
		local_max *= 1.5

	# Get direction
	var direction = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down")
	
	# Clamp velocity
	velocity = velocity.clamp(Vector2.ONE * -local_max, Vector2.ONE * local_max)
	
	if direction and velocity.length() <= local_max:
		velocity.x += direction.x * SPEED
		velocity.y += direction.y * SPEED / 2
	
	# Drag
	velocity.x -= lerp(velocity.x, 0.0, DRAG)
	velocity.y -= lerp(velocity.y, 0.0, DRAG)
	
	animation_player()

	move_and_slide()

func animation_player() -> void:
	var idle_speed = 1.4

	if velocity.y < 0:
		Y_FACING = "north"
	elif velocity.y > 0:
		Y_FACING = "south"
	
	if velocity.x > 0:
		X_FACING = "east"
	elif velocity.x < 0:
		X_FACING = "west"
	
	if Y_FACING == "north" and X_FACING == "east":
		if velocity.length() > idle_speed:
			ANIM.play("RunNE")
		else:
			ANIM.play("IdleNE")

	elif Y_FACING == "north" and X_FACING == "west":
		if velocity.length() > idle_speed:
			ANIM.play("RunNW")
		else:
			ANIM.play("IdleNW")

	elif Y_FACING == "south" and X_FACING == "east":
		if velocity.length() > idle_speed:
			ANIM.play("RunSE")
		else:
			ANIM.play("IdleSE")
	
	elif Y_FACING == "south" and X_FACING == "west":
		if velocity.length() > idle_speed:
			ANIM.play("RunSW")
		else:
			ANIM.play("IdleSW")
