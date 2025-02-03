extends CharacterBody2D

const SPEED = 100.0

@export var MAX_HEALTH = 100.0
var current_health = MAX_HEALTH
var heal_rate = 0.0
var is_dead = false

@onready var HUD = $HUD
@onready var invincibility_timer = $InvincibilityCD
@onready var SPRITE = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var footstep_sounds: AudioStreamPlayer2D = $FootstepSounds
const FOOTSTEP_RATE = 3.0
var current_step = 0.0

var primary_weapon: Node2D
var secondary_weapon: Node2D


func _ready() -> void:
	primary_weapon = $PrimaryWeapon
	secondary_weapon = $GrenadeController
	SPRITE.play("idle")

func set_sprite_direction(velocity):
	var direction = velocity.normalized()
	if direction.x < 0: 
		SPRITE.set_flip_h(true)
	else: 
		SPRITE.set_flip_h(false)
	
	if abs(direction.x) < 0.25 and abs(direction.y) < 0.25:
		SPRITE.play("idle")
	elif abs(direction.x) < 0.25:
		if direction.y > 0:
			SPRITE.play("walk_S")
		else: 
			SPRITE.play("walk_N")
	else:
		if direction.y >= 0:
			SPRITE.play("walk_SE")
		else: 
			SPRITE.play("walk_NE")

func _process(delta: float) -> void:
	# Debug -- freeze or unfreeze player input
	if OS.is_debug_build() and Input.is_action_just_pressed("debug_freeze_unfreeze"):
		if is_physics_processing():
			freeze_input()
		else:
			resume_input()
	
	
	if is_dead:
		SPRITE.play("death")
		
	current_health += heal_rate * delta
	if current_health > MAX_HEALTH:
		current_health = MAX_HEALTH
		end_heal()
	HUD.set_health_percent(current_health / MAX_HEALTH)


func _physics_process(_delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity = direction * SPEED
		if heal_rate > 0:
			end_heal()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	set_sprite_direction(velocity)
	if not (velocity == Vector2.ZERO):
		if current_step == 0.0:
			footstep_sounds.play()
		current_step += FOOTSTEP_RATE * _delta
		if current_step >= 1.0:
			current_step = 0.0
	else: 
		current_step = 0.0
	move_and_slide()


func on_take_damage(damage: float) -> void:
	#if !invincibility_timer.is_stopped():
	#	print_debug(invincibility_timer.time_left)
	#else: 
	#	invincibility_timer.start(300 / 60)
	#	current_health -= damage
	current_health -= damage
	if current_health <= 0:
		current_health = 0
		is_dead = true
		animation_player.play("death")
	
	HUD.set_health_percent(current_health / MAX_HEALTH)

func freeze_input() -> void:
	set_physics_process(false)
	
	primary_weapon.set_process(false)
	primary_weapon.set_physics_process(false)
	
	secondary_weapon.set_process(false)
	secondary_weapon.set_physics_process(false)
	

func resume_input() -> void:
	set_physics_process(true)
	
	primary_weapon.set_process(true)
	primary_weapon.set_physics_process(true)
	
	secondary_weapon.set_process(true)
	secondary_weapon.set_physics_process(true)


func pickup(resource_ref: Resource) -> void:
	var node_ref = load(resource_ref.get_path())
	add_child(node_ref.instantiate())


func begin_heal() -> void:
	print_debug("Beginning heal")
	heal_rate = 20.0


func end_heal() -> void:
	print_debug("Ending heal")
	heal_rate = 0.0
