extends Node2D

const SPEED: int = 600
const TICKS_TO_EXPIRE = 60

var ticks = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(ticks >= TICKS_TO_EXPIRE):
		queue_free()
		pass
	
	position += transform.x * SPEED * delta
	
	ticks += 1
