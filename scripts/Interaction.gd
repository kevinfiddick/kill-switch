extends Node2D

@onready var interaction_icon: Sprite2D = $InteractionIcon

@export var area_ref: Area2D

signal interact

var player_ref: CharacterBody2D
var is_interactable = false


func _ready() -> void:
	area_ref.connect("body_entered", _on_area_body_entered)
	area_ref.connect("body_exited", _on_area_body_exited)
	area_ref.collision_mask = 2


func _process(delta: float) -> void:
	if is_interactable and Input.is_action_just_pressed("interact"):
		interact.emit(player_ref)


func _on_area_body_entered(body: Node2D) -> void:
	if body.has_method("entered_interaction"):
		body.entered_interaction()
	
	player_ref = body
	is_interactable = true
	interaction_icon.visible = true


func _on_area_body_exited(body: Node2D) -> void:
	if body.has_method("exited_interaction"):
		body.exited_interaction()
	
	player_ref = null
	is_interactable = false
	interaction_icon.visible = false
