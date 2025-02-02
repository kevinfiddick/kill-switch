extends Node2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var open_sprite: Resource
@export var closed_sprite: Resource

@export var fight_room: Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_unlock()
	
	fight_room.connect("lock", _lock)
	fight_room.connect("unlock", _unlock)


func _lock() -> void:
	collision_shape_2d.set_deferred("disabled", false)
	sprite_2d.texture = closed_sprite


func _unlock() -> void:
	collision_shape_2d.set_deferred("disabled", true)
	sprite_2d.texture = open_sprite
