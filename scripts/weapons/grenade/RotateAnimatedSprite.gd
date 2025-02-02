extends AnimatedSprite2D

# Speed of rotation in degrees per second
@export var ROTATION_DEGREES_PER_SEC: float = 360.0

func deg2rad(degrees: float) -> float:
	return degrees * (PI / 180)

func _process(delta: float) -> void:
	# Update the rotation of the sprite
	rotation += deg2rad(ROTATION_DEGREES_PER_SEC * delta)
