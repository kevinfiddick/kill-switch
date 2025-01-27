extends Node2D

const SPEED: int = 450
const TICKS_TO_EXPIRE = 60
const DAMAGE = 30

var ticks = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(ticks >= TICKS_TO_EXPIRE):
		queue_free()
		pass
	
	position += transform.x * SPEED * delta
	
	ticks += 1


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(DAMAGE)
