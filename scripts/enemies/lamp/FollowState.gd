extends State

@onready var player = owner.player_reference
@onready var RaycastContext = owner.get_node("RaycastContext")
@onready var SPRITE = owner.get_node("AnimatedSprite2D")
@onready var TAIL = owner.get_node("Tail")
@onready var LOS = owner.get_node("LineOfSight")
@export var in_range_distance = 50.0

func Enter():
	SPRITE.play("idle")
	TAIL.play("default")
	pass

func Exit():
	pass
func Update(delta):
	if owner.dead:
		Transitioned.emit(self, "DeadState")
	if player:
		var player_position = player.get_global_position()
		var owner_position = owner.get_global_position()
		if owner_position.distance_to(player_position) < in_range_distance and LOS.check_los():
			Transitioned.emit(self, "AttackState")

func Physics_Update(delta):
	if player:
		var player_position = player.get_global_position()
		var owner_position = owner.get_global_position()
		var context_map = RaycastContext.get_context_map([player_position])
		var max = context_map.max()
		var index = context_map.find(max)
		var movement_direction = RaycastContext.vector_arr[index]
		owner.movement_and_velocity(movement_direction)

		var facing_direction = (player_position - owner_position).normalized()
		owner.set_facing_direction(facing_direction)
		#var owner_position = owner.get_global_position()
		#var movement_direction = (player_position - owner_position).normalized()
		#owner.movement_and_velocity(movement_direction)
		#owner.set_facing_direction(movement_direction, delta)
