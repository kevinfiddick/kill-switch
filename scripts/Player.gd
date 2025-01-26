extends CharacterBody2D

const SPEED = 300.0

@export var MAX_HEALTH = 100.0
var current_health = MAX_HEALTH

@onready var HUD = $HUD
@onready var invincibility_timer = $InvincibilityCD

func _physics_process(_delta):
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()


func on_take_damage(damage: float) -> void:
	if !invincibility_timer.is_stopped():
		print_debug(invincibility_timer.time_left)
	else: 
		invincibility_timer.start(300 / 60)
		current_health -= damage
	if current_health <= 0:
		current_health = 0
	
	print_debug(current_health)
	print_debug(MAX_HEALTH)
	HUD.set_health_percent(current_health / MAX_HEALTH)
