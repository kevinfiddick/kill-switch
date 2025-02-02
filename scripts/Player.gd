extends CharacterBody2D

const SPEED = 100.0

@export var MAX_HEALTH = 100.0
var current_health = MAX_HEALTH
var heal_rate = 0.0

@onready var HUD = $HUD
@onready var invincibility_timer = $InvincibilityCD

var primary_weapon: Node2D
var secondary_weapon: Node2D


func _ready() -> void:
	primary_weapon = $PrimaryWeapon
	secondary_weapon = $GrenadeController


func _process(delta: float) -> void:
	# Debug -- freeze or unfreeze player input
	if OS.is_debug_build() and Input.is_action_just_pressed("debug_freeze_unfreeze"):
		if is_physics_processing():
			freeze_input()
		else:
			resume_input()
	
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
		end_heal()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

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
