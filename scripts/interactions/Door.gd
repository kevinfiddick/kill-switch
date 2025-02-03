extends Area2D

@onready var interaction: Node2D = $Interaction

@export var fight_room: Node2D
@export var transition_to_scene: Resource

var can_open = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_unlock()
	
	if fight_room != null:
		fight_room.connect("lock", _lock)
		fight_room.connect("unlock", _unlock)
	
	interaction.connect("interact", _on_interact)


func _on_interact(_player_ref: CharacterBody2D) -> void:
	if can_open:
		get_tree().change_scene_to_file(transition_to_scene.resource_path)


func _lock() -> void:
	can_open = false


func _unlock() -> void:
	can_open = true
