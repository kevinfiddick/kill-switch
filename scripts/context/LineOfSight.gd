extends Node2D
class_name LineOfSight2D

@export var line_distance = 100.0
@export var player_reference : Node2D  # Player reference
var in_los = false

signal enter_los
signal exit_los

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func get_los_vector():
	if player_reference:
		var player_position = player_reference.global_position
		# get the vector pointing from global position to point
		var local_vector = player_position - global_position
		# normalize this vector
		local_vector = local_vector.normalized() * line_distance
		return local_vector

func check_los():
	if player_reference:
		var vector = get_los_vector()
		# print(vector)
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(
			global_position, 
			global_position + vector
		)
		var result = space_state.intersect_ray(query)
		if result and result.collider == player_reference:
			if !in_los:
				in_los = true
				enter_los.emit()
		else:
			if in_los:
				in_los = false
				exit_los.emit()
	
func _process(delta):
	if player_reference:
		check_los()
		pass
