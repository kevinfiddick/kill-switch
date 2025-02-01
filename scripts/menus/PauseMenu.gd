extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play("RESET")


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		resume()


func resume():
	get_tree().paused = false
	animation_player.play_backwards("blur")
	

func pause():
	get_tree().paused = true
	animation_player.play("blur")
	

func _on_resume_pressed() -> void:
	resume()


func _on_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()


func _on_quit_pressed() -> void:
	get_tree().quit()
