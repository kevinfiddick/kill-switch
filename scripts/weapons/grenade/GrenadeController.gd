extends Node2D

const PROJECTILE = preload("res://scenes/weapons/grenade/GrenadeProjectile.tscn")
const BASE_ATTACK_SPEED: int = 300 # ticks between shots
const RANGE: float = 100.0 # px ?

signal secondary_used

@export var attack_speed: int = BASE_ATTACK_SPEED
@onready var grenade_throw: AudioStreamPlayer2D = $GrenadeThrow
@onready var grenade_explode_sound: AudioStreamPlayer2D = $GrenadeExplodeSound

var last_shot = attack_speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
		
	# Holding secondary fire shows range
	if Input.is_action_pressed("secondary_fire"):
		pass
	
	# Releasing secondary fire throws grenade projectile
	if Input.is_action_just_released("secondary_fire"):
		if last_shot < attack_speed: return
		else: last_shot = 0
		
		var projectile_instance = PROJECTILE.instantiate()
		projectile_instance.sound_player = grenade_explode_sound
		projectile_instance.end_position = get_global_mouse_position()
		get_tree().root.add_child(projectile_instance)
		grenade_throw.play()
		projectile_instance.global_position = global_position
		projectile_instance.rotation_degrees = rotation_degrees
		if rotation_degrees > 90 and rotation_degrees < 270:
			projectile_instance.scale.y = -1
		else:
			projectile_instance.scale.y = 1
		
		secondary_used.emit()
	

func _physics_process(_delta: float) -> void:
	last_shot += 1
