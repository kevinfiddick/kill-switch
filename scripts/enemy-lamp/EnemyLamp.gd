extends CharacterBody2D

@export var player_reference : Node2D 
@export var SPEED = 30.0


# Function to handle movement and velocity
func movement_and_velocity(move_direction):
	velocity = SPEED * move_direction
	move_and_slide()  # Apply the calculated velocity to the character\
