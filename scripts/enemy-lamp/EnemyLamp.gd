extends CharacterBody2D

@export var player_reference : Node2D 
@export var SPEED = 60.0
@export var STUN_TIMEOUT = 0.75
@export var STUN_SPEED = 30.0
@export var STUN_DMG = 4.0
@export var HEALTH = 30.0

@onready var SPRITE = $AnimatedSprite2D
@onready var TAIL = $Tail
@onready var COLLISION_SHAPE = $CollisionShape2D

var current_health: float = HEALTH
var stunned: bool = false
var stunned_timer: Timer = null
var dead: bool = false

func _ready() -> void:
	SPRITE.play("idle")
	TAIL.play("default")

# Function to handle movement and velocity
func movement_and_velocity(move_direction):
	if not dead:
		if current_health == 0:
			velocity = 0 * move_direction
		elif stunned:
			velocity = STUN_SPEED * move_direction
		else:
			velocity = SPEED * move_direction
		TAIL.set_rotation(velocity.angle())
		move_and_slide()  # Apply the calculated velocity to the character

func _process(delta: float) -> void:
	if not dead:
		if current_health == 0:
			dead = true
			SPRITE.play("dead")
			SPRITE.z_index = 0
			COLLISION_SHAPE.set_disabled(true)
			TAIL.queue_free()
			z_index = 0
		elif stunned:
			if SPRITE.get_animation() != "stunned":
				SPRITE.play("stunned")
			if current_health > 0:
				current_health -= STUN_DMG * delta
				print_debug('ENEMY HEALTH REMAINING: ' + str(current_health) )
			else:
				current_health = 0
				print_debug('ENEMY DEAD: ' + str(current_health) )
		else:
			if SPRITE.get_animation() != "idle":
				SPRITE.play("idle")
		

# Function for taking stun damage from player
func take_stun_damage():
	# Check if a timer is already running
	if stunned_timer and stunned_timer.is_connected("timeout", _on_timer_timeout):
		stunned_timer.disconnect("timeout", _on_timer_timeout)
		stunned_timer.queue_free()
	
	# Create and start a new timer
	stunned_timer = Timer.new()
	stunned_timer.set_one_shot(true)
	stunned_timer.set_wait_time(STUN_TIMEOUT)
	add_child(stunned_timer)
	stunned_timer.start()
	stunned_timer.connect("timeout", _on_timer_timeout)
	stunned = true

func _on_timer_timeout():
	stunned = false
	if stunned_timer and stunned_timer.is_connected("timeout", _on_timer_timeout):
		stunned_timer.queue_free()
		stunned_timer = null
