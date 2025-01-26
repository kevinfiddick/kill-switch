extends CanvasLayer

@onready var grenade_controller: Node2D = $"../GrenadeController"
@onready var grenade_cd: ColorRect = $PanelContainer/MarginContainer/VBoxContainer/GrenadeCD
@onready var grenade_cd_timer: Timer = $PanelContainer/MarginContainer/VBoxContainer/GrenadeCD/GrenadeCDTimer



#func _process(delta: float) -> void:
	#if !grenade_cd_timer.is_stopped():
		#print(grenade_cd_timer.time_left)
		#grenade_cd.scale.y = 300
		#pass

#func _on_grenade_controller_grenade_thrown() -> void:
	#grenade_cd_timer.start(5)
