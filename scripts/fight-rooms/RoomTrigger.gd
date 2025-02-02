extends Area2D

@export var fight_room: Node2D


func _on_body_entered(body: Node2D) -> void:
	if fight_room.has_method("lock_room"):
		fight_room.lock_room()
