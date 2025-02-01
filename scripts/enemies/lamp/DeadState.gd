extends State

@onready var animation_player = owner.get_node("AnimationPlayer")

func Enter():
	animation_player.play("RESET")
	owner.reset_rotation()
	pass

func Exit():
	pass

func Update(delta):
	pass

func Physics_Update(delta):
	pass
