extends State

@onready var player = owner.player_reference
@export var in_range_distance = 20.0

func Enter():
	pass
func Exit():
	pass
func Update(delta):
	if player:
		var player_position = player.get_global_position()
		var owner_position = owner.get_global_position()
		if owner_position.distance_to(player_position) < in_range_distance:
			print_debug("In Attack Range")
			#Transitioned.emit(self, "AttackState")

func Physics_Update(delta):
	if player:
		var player_position = player.get_global_position()
		var owner_position = owner.get_global_position()
		var movement_direction = (player_position - owner_position).normalized()
		owner.movement_and_velocity(movement_direction)
		#owner.set_facing_direction(movement_direction, delta)
