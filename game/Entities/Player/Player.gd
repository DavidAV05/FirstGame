extends CharacterBody2D

@onready var ANIM: AnimatedSprite2D = $AnimatedSprite2D

@export var SPEED: float = 50.0
@export var JUMP_VELOCITY: float = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	ANIM.play("Idle")

func _physics_process(_delta):
	if Isometric:
		print("Loaded")
	else:
		print("Not loaded :(")

	move_and_slide()
