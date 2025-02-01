extends CharacterBody2D

const SPEED = 100.0

@export var MAX_HEALTH = 100.0
var current_health = MAX_HEALTH

@onready var HUD = $HUD
@onready var invincibility_timer = $InvincibilityCD

var primary_weapon: Node2D
var secondary_weapon: Node2D
var interaction_ref: Node2D


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
	#if !invincibility_timer.is_stopped():
	#	print_debug(invincibility_timer.time_left)
	#else: 
	#	invincibility_timer.start(300 / 60)
	#	current_health -= damage
	current_health -= damage
	if current_health <= 0:
		current_health = 0
	
	print_debug(current_health)
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


func entered_interaction(ref: Node2D) -> void:
	interaction_ref = ref


func exited_interaction() -> void:
	interaction_ref = null
