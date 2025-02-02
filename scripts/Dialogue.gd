extends CanvasLayer

@onready var rich_text_label: RichTextLabel = $PanelContainer/HBoxContainer/MarginContainer/RichTextLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var texture_rect: TextureRect = $PanelContainer/HBoxContainer/TextureRect

@export var interact_ref: Node2D
@export var dialogue_icon: Resource
@export var dialogue_text: String
@export var text_speed: int

var text_count = 0


func _ready() -> void:
	interact_ref.connect("interact", _on_interact)
	texture_rect.texture = dialogue_icon


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("dialogue_click"):
		if text_count < dialogue_text.length():
			rich_text_label.text = dialogue_text
			text_count = dialogue_text.length()
		else:
			end_dialogue()
	else:
		if text_count < dialogue_text.length():
			rich_text_label.text += dialogue_text.substr(text_count, text_speed)
			text_count += text_speed


func _on_interact() -> void:
	play_dialogue()


func play_dialogue() -> void:
	get_tree().paused = true
	animation_player.play("show")


func end_dialogue() -> void:
	get_tree().paused = false
	animation_player.play("RESET")
