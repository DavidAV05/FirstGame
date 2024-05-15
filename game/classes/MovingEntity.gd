extends CharacterBody2D
class_name MovingEntity

@export var SPEED : int
@export var PATH_FINDING : PathFinding

func _process(delta):

func move_to(entity: MovingEntity, position: Vector2) -> void:
	var direction := (entity.global_position - position).normalized()
	entity.velocity = direction * entity.SPEED