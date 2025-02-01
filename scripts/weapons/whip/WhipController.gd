extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const BASE_ATTACK_SPEED = 35 # ticks between shots
const DAMAGE = 20

signal special_1_used

@export var attack_speed: int = BASE_ATTACK_SPEED

var last_shot = attack_speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !animation_player.is_playing():
		look_at(get_global_mouse_position())
	
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
		
	# Primary fire shoots projectile
	if Input.is_action_pressed("special_1"):
		if last_shot < attack_speed: return
		else: last_shot = 0
		
		special_1_used.emit()
		
		animation_player.play("attack")

func _physics_process(_delta: float) -> void:
	last_shot += 1
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(DAMAGE)
