extends Node2D

@export var pickup_reference: Resource


func _physics_process(delta: float) -> void:
	# May add bobbing movement
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("pickup"):
		body.pickup(pickup_reference)
		queue_free()
