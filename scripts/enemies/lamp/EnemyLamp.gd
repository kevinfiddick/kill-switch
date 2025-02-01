extends CharacterBody2D

@export var player_reference : Node2D 
@export var SPEED = 75.0
@export var STUN_TIMEOUT = 1.0
@export var STUN_SPEED = 30.0
@export var STUN_DMG = 4.0
@export var HEALTH = 30.0

@onready var SPRITE = $AnimatedSprite2D
@onready var TAIL = $Tail
@onready var COLLISION_SHAPE = $CollisionShape2D

var current_health: float = HEALTH
var stunned_timer: Timer = null
var dead: bool = false
var effects = {
	"shock": {
		"is_shocked": false,
		"shock_hit_count": 0,
		"HITS_TO_SHOCK": 3,
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

func _process(delta: float) -> void:
	if not dead:
		if current_health <= 0:
			dead = true
			SPRITE.play("dead")
			SPRITE.z_index = 0
			COLLISION_SHAPE.set_disabled(true)
			TAIL.queue_free()
			z_index = 0
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
	
	print_debug('DAMAGED - ENEMY HEALTH REMAINING: ' + str(current_health) )
	
	# Apply effects
	if apply_effects != null:
		for effect in apply_effects:
			if effect == "shock":
				apply_shock()


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
	print_debug("AREA ENTERED")
	if body == player_reference:
		body.on_take_damage(5)
	pass # Replace with function body.
