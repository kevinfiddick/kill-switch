extends CharacterBody2D

@export var player_reference : Node2D 
@export var fight_room: Node2D
@export var SPEED = 75.0
@export var STUN_TIMEOUT = 1.0
@export var STUN_SPEED = 30.0
@export var STUN_DMG = 4.0
@export var HEALTH = 30.0
@export var DAMAGE = 5.0

@onready var SPRITE = $AnimatedSprite2D
@onready var TAIL = $Tail
@onready var COLLISION_SHAPE = $CollisionShape2D
@onready var death_sound: AudioStreamPlayer2D = $Audio/DeathSound
@onready var hit_sound: AudioStreamPlayer = $Audio/HitSound
@onready var whip_hit: AudioStreamPlayer2D = $Audio/WhipHit


var current_health: float = HEALTH
var stunned_timer: Timer = null
var dead: bool = false
var effects = {
	"shock": {
		"is_shocked": false,
		"shock_hit_count": 0,
		"HITS_TO_SHOCK": 1,
	}
}


#func _ready() -> void:
#	SPRITE.play("idle")
#	TAIL.play("default")

func set_facing_direction(facing_direction):
	if not dead:
		TAIL.set_rotation(facing_direction.angle())


# Function to handle movement and velocity
func movement_and_velocity(move_direction):
	if not dead:
		if current_health == 0:
			velocity = 0 * move_direction
		elif effects.shock.is_shocked:
			velocity = STUN_SPEED * move_direction
		else:
			velocity = SPEED * move_direction
		move_and_slide()  # Apply the calculated velocity to the character


# Utility function for rounding numbers to a specified number of decimal places
func round_place(num, places):
	return (round(num * pow(10, places)) / pow(10, places))

# Function to get the current direction of the character based on its rotation
func get_curr_direction():
	var angle = get_rotation()  # Get current rotation in radians
	# Calculate direction vector from angle, rounded to 4 decimal places for precision
	var direction = Vector2(round_place(cos(angle), 4), round_place(sin(angle), 4)).normalized()
	return direction

# Function to calculate the difference in degrees between two vectors
func angle_diff_degrees(a: Vector2, b: Vector2):
	# Calculate the signed angle in radians between two vectors
	var signed_angle = atan2(b.y, b.x) - atan2(a.y, a.x)

	# Convert angle to degrees
	var angle_degrees = rad_to_deg(signed_angle)

	# Normalize the angle to be within the range of -180 to 180 degrees
	while angle_degrees > 180:
		angle_degrees -= 360
	while angle_degrees < -180:
		angle_degrees += 360

	return angle_degrees

func reset_rotation():
	set_rotation_degrees(0.0)
	SPRITE.set_rotation_degrees(0.0)

func set_attack_direction(direction):
	var new_rotation = direction.angle() + PI
	set_rotation(new_rotation)  # Apply the new rotation to the sprite
	SPRITE.set_rotation(0 - new_rotation)

func _process(delta: float) -> void:
	if not dead:
		if current_health <= 0:
			dead = true
			death_sound.play()
			SPRITE.play("dead")
			SPRITE.z_index = 0
			COLLISION_SHAPE.set_disabled(true)
			TAIL.queue_free()
			z_index = 0
			fight_room.remove_objective()
		elif effects.shock.is_shocked:
			if SPRITE.get_animation() != "stunned":
				SPRITE.play("stunned")
			if current_health > 0:
				current_health -= STUN_DMG * delta
				print_debug('SHOCKED - ENEMY HEALTH REMAINING: ' + str(current_health) )
			else:
				current_health = 0
				print_debug('ENEMY DEAD: ' + str(current_health) )
		else:
			if SPRITE.get_animation() != "idle":
				SPRITE.play("idle")


# Function for taking damage
func take_damage(damage: float, apply_effects: Array = []):
	# Apply damage
	current_health -= damage
	if current_health < 0:
		current_health = 0
	
	#print_debug('DAMAGED - ENEMY HEALTH REMAINING: ' + str(current_health) )
	
	# Apply effects
	if apply_effects != null:
		for effect in apply_effects:
			if effect == "shock":
				apply_shock()
				
	#Play Sound
	if not dead and current_health > 0:
		hit_sound.play()
		


# Apply shock effect to enemy
func apply_shock():
	effects.shock.shock_hit_count += 1
	
	if effects.shock.shock_hit_count >= effects.shock.HITS_TO_SHOCK:
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
		
		effects.shock.is_shocked = true
		effects.shock.shock_hit_count = 0


func _on_timer_timeout():
	effects.shock.is_shocked = false
	if stunned_timer and stunned_timer.is_connected("timeout", _on_timer_timeout):
		stunned_timer.queue_free()
		stunned_timer = null


func _on_area_2d_body_entered(body: Node2D) -> void:
	# print_debug("AREA ENTERED")
	if body == player_reference:
		body.on_take_damage(DAMAGE)

		whip_hit.play()
	pass # Replace with function body.


func _on_whip_area_2d_area_entered(area: Area2D) -> void:
	print_debug("AREA ENTERED")
	print_debug(player_reference)
	print_debug(area)
	pass # Replace with function body.


func _ready() -> void:
	fight_room.add_objective()
