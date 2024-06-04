extends Area2D


@onready var Sprite: Sprite2D = $Sprite2D
@onready var Collision: CollisionPolygon2D = $CollisionPolygon2D
@onready var Ray: RayCast2D = $RayCast2D


@export_category("✨ Appereance")
@export var SPRITE_IMG: Texture2D
@export var width: int = 1
@export var height: int = 1
@export_category("Movement")
@export var MOVEMENT_SPEED: float = 8


var ABS_DIRECTIONS = [
	Vector2(2, 1),
	Vector2(-2, 1),
	Vector2(2, -1),
	Vector2(-2, -1),
	]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Sprite.texture = SPRITE_IMG
	Ray.add_exception(self)
	
	for dir: Vector2 in ABS_DIRECTIONS:
		dir = dir.normalized()


func check_free_space(move_vec: Vector2) -> bool:
	print(Ray.target_position)
	Ray.target_position = move_vec * 2
	print(Ray.target_position)
	print(Ray.is_colliding())
	return not Ray.is_colliding()


func move(relative_dir: Vector2) -> void:
	# Translate dir to ABS_DIRECTION
	# [0] = dot product, [1] = index
	var highest_val = 0
	var highest_index = 0
	var i = 0
	
	# Check which ABS_DIR is closest to dir
	for ABS_DIR in ABS_DIRECTIONS:
		var dot = ABS_DIR.dot(relative_dir)
		if dot >= highest_val:
			highest_val = dot
			highest_index = i
		i += 1
	print(self.global_position)
	var movement_vec = ABS_DIRECTIONS[highest_index] * MOVEMENT_SPEED
	
	
	if check_free_space(movement_vec):
		self.global_position += movement_vec
	
	# Cooldown
	await get_tree().create_timer(1).timeout


func _on_body_entered(body) -> void:
	var relative_dir = self.global_position - body.global_position
	move(relative_dir)
