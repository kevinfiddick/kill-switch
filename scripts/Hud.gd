extends CanvasLayer

const WEAPON_CONTROLLERS = [
	"../GrenadeController",
	"../BladeController",
]

@onready var secondary_cd: ColorRect = $PanelContainer/MarginContainer/VBoxContainer/SecondaryCDRef/SecondaryCD
@onready var secondary_cd_timer: Timer = $PanelContainer/MarginContainer/VBoxContainer/SecondaryCDRef/SecondaryCD/SecondaryCDTimer

@onready var health_bar: ColorRect = $PanelContainer/MarginContainer/VBoxContainer/HealthBarRef/HealthBar

var controller_ref: Node2D

func _ready() -> void:
	controller_ref = $"../GrenadeController"
	controller_ref.connect("secondary_used", _on_secondary_used)

func _process(delta: float) -> void:
	if controller_ref == null:
		for weapon in WEAPON_CONTROLLERS:
			var controller = get_node_or_null(weapon)
			if controller != null:
				controller_ref = controller
				controller_ref.connect("secondary_used", _on_secondary_used)
				break
	
	if !secondary_cd_timer.is_stopped():
		secondary_cd.scale.x = 1 - (secondary_cd_timer.time_left / (controller_ref.attack_speed / 60))
		if secondary_cd.get_color() != Color("#FFFFFF"):
			secondary_cd.set_color("#FFFFFF")
	else: 
		if secondary_cd.get_color() != Color("#FFDE21"):
			secondary_cd.set_color("#FFDE21")


func set_health_percent(percent: float) -> void:
	health_bar.scale.x = percent
	
	
func _on_secondary_used() -> void:
	secondary_cd_timer.start(300 / 60)
