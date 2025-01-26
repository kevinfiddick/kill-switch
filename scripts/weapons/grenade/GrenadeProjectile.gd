extends Node2D

@export var end_position: Vector2

const SPEED: int = 300
const TICKS_TO_EXPIRE: int = 600

var ticks = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if ticks >= TICKS_TO_EXPIRE:
		queue_free()
		pass
	
	var x_direction
	var y_direction
	if rotation_degrees >= 90 and rotation_degrees < 270:
		x_direction = -1
	else: x_direction = 1
	if rotation_degrees >= 0 and rotation_degrees < 180:
		y_direction = 1
	else: y_direction = -1
	
	if (position.x * x_direction > end_position.x * x_direction) and (position.y * y_direction > end_position.y * y_direction):
		queue_free()
		pass
	
	position += transform.x * SPEED * delta
	
	ticks += 1
