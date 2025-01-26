extends CanvasLayer

@onready var grenade_controller: Node2D = $"../GrenadeController"
@onready var grenade_cd: ColorRect = $PanelContainer/MarginContainer/VBoxContainer/ReferenceRect/GrenadeCD
@onready var grenade_cd_timer: Timer = $PanelContainer/MarginContainer/VBoxContainer/ReferenceRect/GrenadeCD/GrenadeCDTimer

@onready var health_bar: ColorRect = $PanelContainer/MarginContainer/VBoxContainer/HealthBarRef/HealthBar

func _process(delta: float) -> void:
	if !grenade_cd_timer.is_stopped():
		print(grenade_cd_timer.time_left)
		grenade_cd.scale.x = 1 - (grenade_cd_timer.time_left / (300 / 60))
		if grenade_cd.get_color() != Color("#FFFFFF"):
			grenade_cd.set_color("#FFFFFF")
	else: 
		if grenade_cd.get_color() != Color("#FFDE21"):
			grenade_cd.set_color("#FFDE21")

func set_health_percent(percent: float) -> void:
	health_bar.scale.x = percent
	

func _on_grenade_controller_grenade_thrown() -> void:
	grenade_cd_timer.start(300 / 60)
