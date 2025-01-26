extends CharacterBody2D

@export var player_reference : Node2D 
@export var SPEED = 60.0
@export var STUN_SPEED = 30.0
@export var HEALTH = 30.0
@export var STUN_TIMEOUT = 2

var stunned: bool = false
var stunned_timer: Timer = null

# Function to handle movement and velocity
func movement_and_velocity(move_direction):
	if stunned:
		velocity = STUN_SPEED * move_direction
	else:
		velocity = SPEED * move_direction
	move_and_slide()  # Apply the calculated velocity to the character\

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
