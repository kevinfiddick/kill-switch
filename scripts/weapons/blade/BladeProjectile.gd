extends Node2D

const SPEED: int = 450
const TICKS_TO_EXPIRE = 3600
const DAMAGE = 30
const RANGE = 100 # pixels
const TICKS_TO_ACCELERATE = 20 # ticks

@export var controller_parent : CharacterBody2D

var ticks = 0
var distance_travelled = 0
var current_speed = SPEED
var ticks_accelerating = 0
var following_parent = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(ticks >= TICKS_TO_EXPIRE):
		queue_free()
		pass
		
	if distance_travelled >= RANGE:
		if following_parent and current_speed < SPEED:
			look_at(controller_parent.position)
			if rotation_degrees > 90 and rotation_degrees < 270:
				scale.y = -1
			else:
				scale.y = 1
				
			current_speed += SPEED / TICKS_TO_ACCELERATE
			
			if current_speed > SPEED:
				current_speed = SPEED
		else:
			current_speed -= SPEED / TICKS_TO_ACCELERATE
			ticks_accelerating += 1
			
			if ticks_accelerating >= TICKS_TO_ACCELERATE:
				following_parent = true
				ticks_accelerating = 0
		
	position += transform.x * current_speed * delta
	distance_travelled += current_speed * delta
	
	
	ticks += 1


func _on_area_2d_body_entered(body: Node2D) -> void:
	var is_parent = controller_parent == body
	
	if body.has_method("take_damage") and !is_parent:
		body.take_damage(DAMAGE)
		
	if is_parent and following_parent:
		queue_free()
