extends Node2D

const PROJECTILE = preload("res://scenes/weapons/primary/PrimaryProjectile.tscn")

@onready var muzzle: Marker2D = $Marker2D

var projectiles = []
var cooldown = 25
var last_shot = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	last_shot += 1
	
	look_at(get_global_mouse_position())
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
	
	# Primary fire shoots projectile
	if Input.is_action_just_pressed("primary_fire"):
		if last_shot < cooldown: return
		else: last_shot = 0
		
		var projectile_instance = PROJECTILE.instantiate()
		get_tree().root.add_child(projectile_instance)
		projectile_instance.global_position = muzzle.global_position
		projectile_instance.rotation = rotation
