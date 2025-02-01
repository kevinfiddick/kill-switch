extends Node2D

const PROJECTILE = preload("res://scenes/weapons/blade/BladeProjectile.tscn")
const BASE_ATTACK_SPEED = 300 # ticks between shots

signal special_2_used

@export var attack_speed: int = BASE_ATTACK_SPEED

var last_shot = attack_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
		
	# Releasing secondary fire throws grenade projectile
	if Input.is_action_just_pressed("special_2"):
		if last_shot < attack_speed: return
		else: last_shot = 0
		
		var projectile_instance = PROJECTILE.instantiate()
		get_tree().root.add_child(projectile_instance)
		projectile_instance.global_position = global_position
		projectile_instance.rotation_degrees = rotation_degrees
		if rotation_degrees > 90 and rotation_degrees < 270:
			projectile_instance.scale.y = -1
		else:
			projectile_instance.scale.y = 1
			
		projectile_instance.controller_parent = get_parent()
		
		special_2_used.emit()


func _physics_process(_delta: float) -> void:
	last_shot += 1
