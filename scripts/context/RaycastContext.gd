extends Node2D
class_name RaycastContext2D

@export var raycast_distance = 20
@export var danger_value = 5.0
@export var danger_buffer_value = 2.0
var vector_arr = []
var raycast_vector_arr = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var step = 0.125 * PI  # Increment step in radians
	for i in range(0, int(2 * PI / step)):
		var angle = i * step
		var direction = Vector2(cos(angle), sin(angle)).normalized()
		# Add the direction to your arrays as needed
		vector_arr.append(direction)
		raycast_vector_arr.append(direction * raycast_distance)

# dot product can be used to find the vector that points towards desired point
func get_interest_arr(point : Vector2):
	# get the vector pointing from global position to point
	var local_vector = point - global_position
	# normalize this vector
	local_vector = local_vector.normalized()
	var dot_product = [];
	# get the dot product of each directional vector in the vector_arr
	# this will give you a value of interest for each direction
	for v in vector_arr:
		dot_product.append(v.dot(local_vector))
	return dot_product

func get_danger_arr():
	var danger_arr = []
	# Initialize danger_arr with zeros, matching the length of raycast_vector_arr
	for i in len(raycast_vector_arr):
		danger_arr.append(0)
	
	var space_state = get_world_2d().direct_space_state
	for i in len(raycast_vector_arr):
		var prev = i - 1
		if prev < 0: prev = len(raycast_vector_arr) - 1
		var next = i + 1
		if next >= len(raycast_vector_arr): next = 0
		var query = PhysicsRayQueryParameters2D.create(
			global_position, 
			global_position + raycast_vector_arr[i]
		)
		var result = space_state.intersect_ray(query)
		if result:
			danger_arr[i] += danger_value
			danger_arr[prev] += danger_buffer_value
			danger_arr[next] += danger_buffer_value
	
	return danger_arr

func do_array_math(arr1, arr2, f : Callable):
	var sum = [];
	assert(
		len(arr1) == len(arr2), 
		"ERROR, CANNOT ADD DIFF SIZE ARRAYS, " + str(len(arr1))+ " != " + str(len(arr2))
	)
	for i in len(arr1):
		sum.append(f.call(arr1[i], arr2[i]))
	return sum

func get_context_map(points: Array):
	var interest_arr;
	for point in points:
		var interest_arr_part = get_interest_arr(point)
		if interest_arr:
			interest_arr = do_array_math(
				interest_arr,
				interest_arr_part, 
				func sum(a,b): return a + b
			)
		else:
			interest_arr = interest_arr_part
		
	var danger_arr = get_danger_arr()
	var context_map = do_array_math(
		interest_arr,
		danger_arr, 
		func sub(a,b): return a - b
	)
	return context_map

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	pass
