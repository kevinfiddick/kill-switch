extends Node2D

const PROJECTILE = preload("res://scenes/enemies/blender/EnemyBladeProjectile.tscn")
@onready var player = owner.player_reference

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(player.get_position())
	
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
		
	# Releasing secondary fire throws grenade projectile
	if Input.is_action_just_pressed("secondary_fire"):
		var projectile_instance = PROJECTILE.instantiate()
		get_tree().root.add_child(projectile_instance)
		projectile_instance.global_position = global_position
		projectile_instance.rotation_degrees = rotation_degrees
		if rotation_degrees > 90 and rotation_degrees < 270:
			projectile_instance.scale.y = -1
		else:
			projectile_instance.scale.y = 1
		
