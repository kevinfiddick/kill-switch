extends Node2D

@export var interact_ref: Node2D


func _ready() -> void:
	interact_ref.connect("interact", _on_interact)


func _on_interact(player_ref: CharacterBody2D) -> void:
	if player_ref.has_method("begin_heal"):
		player_ref.begin_heal()
