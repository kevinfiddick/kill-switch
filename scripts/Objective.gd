extends Node2D

@export var fight_room: Node2D
@export var health: float = 100.0
@export var objective_sprite: AnimatedSprite2D
@export var destroyed_sprite: Sprite2D

var is_destroyed = false


func _ready() -> void:	
	objective_sprite.visible = true
	destroyed_sprite.visible = false
	
	fight_room.add_objective()


func take_damage(damage: int, _effects = null) -> void:
	health -= damage
	print("OBJECTIVE DAMAGE TAKEN. HEALTH: " + str(health))
	
	if health <= 0:
		fight_room.remove_objective()
		
		objective_sprite.visible = false
		destroyed_sprite.visible = true
