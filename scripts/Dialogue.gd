extends CanvasLayer

@onready var rich_text_label: RichTextLabel = $PanelContainer/HBoxContainer/MarginContainer/RichTextLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var texture_rect: TextureRect = $PanelContainer/HBoxContainer/TextureRect
@onready var lore_sound = $LoreSound

@export var interact_ref: Node2D
@export var dialogue_icon: Resource
@export_multiline var dialogue_text: String
@export var text_speed: int
@export var play_lore_sound: bool = true

var text_count = 0


func _ready() -> void:
	interact_ref.connect("interact", _on_interact)
	texture_rect.texture = dialogue_icon
	rich_text_label.text = dialogue_text


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("dialogue_click"):
		end_dialogue()


func _on_interact(_player_ref: CharacterBody2D) -> void:
	if play_lore_sound:
		lore_sound.play()
	play_dialogue()


func play_dialogue() -> void:
	get_tree().paused = true
	animation_player.play("show")


func end_dialogue() -> void:
	get_tree().paused = false
	animation_player.play("RESET")
