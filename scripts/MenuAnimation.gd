extends AnimatedSprite2D
@onready var panel_container: PanelContainer = $"../PanelContainer"

var loop = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("default")
	panel_container.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_playing() and not loop:
		loop = true
		play("loop")
		panel_container.visible = true
	pass
