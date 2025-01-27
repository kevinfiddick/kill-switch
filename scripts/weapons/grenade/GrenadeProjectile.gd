extends Node2D

const SHRAPNEL = preload("res://scenes/weapons/grenade/GrenadeShrapnel.tscn")

const SPEED: int = 300
const TICKS_TO_EXPIRE: int = 600
const NUMBER_SHRAPNEL: int = 10
@export var DEBUG_DO_NOT_EXPLODE: bool = false

@export var end_position: Vector2
@onready var SPRITE = $Sprite2D

var ticks = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not DEBUG_DO_NOT_EXPLODE: 
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
		
		# If grenade position passes end position
		if (position.x * x_direction > end_position.x * x_direction) and (position.y * y_direction > end_position.y * y_direction):
			# Spawn shrapnel
			for i in NUMBER_SHRAPNEL:
				var shrapnel_instance = SHRAPNEL.instantiate()
				get_tree().root.add_child(shrapnel_instance)
				shrapnel_instance.global_position = global_position
				
				# Create full circle of shrapnel, but randomize rotation within segments
				var degree = 360 / NUMBER_SHRAPNEL * i
				shrapnel_instance.rotation_degrees = degree + (randf() * (360 / NUMBER_SHRAPNEL))
				
				if shrapnel_instance.rotation_degrees > 90 and shrapnel_instance.rotation_degrees < 270:
					shrapnel_instance.scale.y = -1
				else:
					shrapnel_instance.scale.y = 1
			queue_free()
			pass
		
		position += transform.x * SPEED * delta
		
		ticks += 1
