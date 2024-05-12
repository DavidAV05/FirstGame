extends CharacterBody2D

@export var nav_region : NavigationRegion2D
@export var target : CharacterBody2D
@export var speed : int = 5000


@onready var path_find : PathFinding = $PathFinding

func _ready():
	path_find.nav_region = nav_region
	path_find.target = target

func _physics_process(delta):
	var dir := path_find.get_direction()
	velocity = dir * speed * delta
	print("Beater dir: ", dir)
	
	move_and_slide()
