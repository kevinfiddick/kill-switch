extends CanvasLayer

@onready var grenade_controller: Node2D = $"../GrenadeController"
@onready var grenade_cd: ColorRect = $PanelContainer/MarginContainer/VBoxContainer/ReferenceRect/GrenadeCD
@onready var grenade_cd_timer: Timer = $PanelContainer/MarginContainer/VBoxContainer/ReferenceRect/GrenadeCD/GrenadeCDTimer


func _process(delta: float) -> void:
	if !grenade_cd_timer.is_stopped():
		print(grenade_cd_timer.time_left)
		grenade_cd.scale.y = 1 - (grenade_cd_timer.time_left / (300 / 60))
		pass


func _on_grenade_controller_grenade_thrown() -> void:
	grenade_cd_timer.start(300 / 60)
