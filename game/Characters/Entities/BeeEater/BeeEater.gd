extends MovingEntity
# class_name BeeEater

# @export var target : CharacterBody2D

# @onready var path_find : PathFinding = $PathFinding

# func _ready():
# 	path_find.target = target

# func _physics_process(delta):
# 	var dir := path_find.get_direction()
# 	velocity = dir * SPEED * delta

# 	move_and_slide()
