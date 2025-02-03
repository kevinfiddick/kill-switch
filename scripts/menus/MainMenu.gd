extends Control


@onready var main_menu_music: AudioStreamPlayer = $"Main Menu Music"
@onready var main_menu_music_end: AudioStreamPlayer = $"Main Menu Music End"

func _ready() -> void:
	main_menu_music.play()

func _on_play_pressed() -> void:
	main_menu_music_end.play()
	main_menu_music.stop()
	get_tree().change_scene_to_file("res://scenes/levels/bedroom/Bedroom.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
