extends Node2D

const SPEED: int = 300
const TICKS_TO_EXPIRE = 120

var ticks

func _ready() -> void:
	ticks = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(ticks >= TICKS_TO_EXPIRE):
		queue_free()
		pass
	
	position += transform.x * SPEED * delta
	
	ticks += 1
