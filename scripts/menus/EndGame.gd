extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_quit_pressed() -> void:
	get_tree().quit()
