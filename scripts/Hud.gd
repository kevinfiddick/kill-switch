extends CanvasLayer

@onready var secondary_cd: ColorRect = $PanelContainer/MarginContainer/VBoxContainer/SecondaryCDRef/SecondaryCD
@onready var secondary_cd_timer: Timer = $PanelContainer/MarginContainer/VBoxContainer/SecondaryCDRef/SecondaryCD/SecondaryCDTimer

@onready var special_1cd: ColorRect = $PanelContainer/MarginContainer/VBoxContainer/Special1CDRef/Special1CD
@onready var special_1cd_timer: Timer = $PanelContainer/MarginContainer/VBoxContainer/Special1CDRef/Special1CD/Special1CDTimer

@onready var special_2cd: ColorRect = $PanelContainer/MarginContainer/VBoxContainer/Special2CDRef/Special2CD
@onready var special_2cd_timer: Timer = $PanelContainer/MarginContainer/VBoxContainer/Special2CDRef/Special2CD/Special2CDTimer

@onready var health_bar: ColorRect = $PanelContainer/MarginContainer/VBoxContainer/HealthBarRef/HealthBar

var cooldowns = {
	"secondary": {
		"ref": null,
		"path": "../GrenadeController",
		"signal_name": "secondary_used",
		"signal_func": _on_secondary_used,
	},
	"special_1": {
		"ref": null,
		"path": "../WhipController",
		"signal_name": "special_1_used",
		"signal_func": _on_special_1_used,
	},
	"special_2": {
		"ref": null,
		"path": "../BladeController",
		"signal_name": "special_2_used",
		"signal_func": _on_special_2_used,
	},
}

func _ready() -> void:
	cooldowns.secondary.ref = $"../GrenadeController"
	cooldowns.secondary.ref.connect(cooldowns.secondary.signal_name, cooldowns.secondary.signal_func)

func _process(delta: float) -> void:
	for cd_key in cooldowns:
		var cd_value = cooldowns[cd_key]
		if cd_value.ref == null:
			var ref = get_node_or_null(cd_value.path)
			if ref != null:
				cd_value.ref = ref
				cd_value.ref.connect(cd_value.signal_name, cd_value.signal_func)
				break
	
	# Set colors on secondary cooldown
	if !secondary_cd_timer.is_stopped():
		secondary_cd.scale.x = 1 - (secondary_cd_timer.time_left / (cooldowns.secondary.ref.attack_speed / 60.0))
		if secondary_cd.get_color() != Color("#FFFFFF"):
			secondary_cd.set_color("#FFFFFF")
	else: 
		if secondary_cd.get_color() != Color("#FFDE21"):
			secondary_cd.set_color("#FFDE21")
	
	# Set colors on special 1 cooldown
	if !special_1cd_timer.is_stopped():
		special_1cd.scale.x = 1 - (special_1cd_timer.time_left / (cooldowns.special_1.ref.attack_speed / 60.0))
		if special_1cd.get_color() != Color("#FFFFFF"):
			special_1cd.set_color("#FFFFFF")
	else: 
		if special_1cd.get_color() != Color("#FFDE21"):
			special_1cd.set_color("#FFDE21")
	
	# Set colors on special 2 cooldown
	if !special_2cd_timer.is_stopped():
		special_2cd.scale.x = 1 - (special_2cd_timer.time_left / (cooldowns.special_2.ref.attack_speed / 60.0))
		if special_2cd.get_color() != Color("#FFFFFF"):
			special_2cd.set_color("#FFFFFF")
	else: 
		if special_2cd.get_color() != Color("#FFDE21"):
			special_2cd.set_color("#FFDE21")


func set_health_percent(percent: float) -> void:
	health_bar.scale.x = percent
	
	
func _on_secondary_used() -> void:
	secondary_cd_timer.start(cooldowns.secondary.ref.attack_speed / 60.0)


func _on_special_1_used() -> void:
	print(cooldowns.special_1)
	special_1cd_timer.start(cooldowns.special_1.ref.attack_speed / 60.0)


func _on_special_2_used() -> void:
	special_2cd_timer.start(cooldowns.special_2.ref.attack_speed / 60.0)
