extends Node2D

const PROJECTILE = preload("res://scenes/weapons/primary/PrimaryProjectile.tscn")
const PROJECTILE_SPREAD = 15.0 # degrees
const BASE_ATTACK_SPEED = 10 # ticks between shots

@onready var muzzle: Marker2D = $Marker2D
@onready var sounds: AudioStreamPlayer2D = $GunSound

var last_shot = BASE_ATTACK_SPEED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
	
	# Primary fire shoots projectile
	if Input.is_action_pressed("primary_fire"):
		
		if last_shot < BASE_ATTACK_SPEED: return
		else: last_shot = 0
		
		var projectile_instance = PROJECTILE.instantiate()
		get_tree().root.add_child(projectile_instance)
		sounds.play()
		projectile_instance.global_position = muzzle.global_position
		projectile_instance.rotation_degrees = rotation_degrees + (randf() * PROJECTILE_SPREAD - (PROJECTILE_SPREAD / 2.0))


func _physics_process(_delta: float) -> void:
	last_shot += 1
	
