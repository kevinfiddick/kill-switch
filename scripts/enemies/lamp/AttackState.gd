extends State

@onready var animation_player = owner.get_node("AnimationPlayer")
@onready var player = owner.player_reference
var is_playing = false
var has_played = false
var attack_timer = 0.0
var ATTACK_TIMEOUT = 1.333333333

func Enter():
	has_played = false
	pass
func Exit():
	has_played = false
	animation_player.play("RESET")
	owner.reset_rotation()
	pass
func Update(delta):
	if not owner.dead and is_playing:
		attack_timer -= delta
		if attack_timer <= 0:
			is_playing = false
			has_played = true
			animation_player.stop()
	elif owner.dead:
		#is_playing = false
		#has_played = true
		#animation_player.stop()
		Transitioned.emit(self, "DeadState")
		
	

func get_local_vector():
	if player:
		var player_position = player.get_global_position()
		var owner_position = owner.get_global_position()
		# get the vector pointing from global position to point
		var local_vector = player_position - owner_position
		# normalize this vector
		local_vector = local_vector.normalized()
		return local_vector
	
func Physics_Update(delta):
	if !animation_player.is_playing() and !has_played: 
		# owner.music_reference.PlayAttackSound()
		animation_player.play("attack")
		is_playing = true
		attack_timer = ATTACK_TIMEOUT
		var player_position = player.get_global_position()
		var owner_position = owner.get_global_position()
		var facing_direction = (player_position - owner_position).normalized()
		owner.set_attack_direction(facing_direction)
	elif has_played: 
		animation_player.stop()
		Transitioned.emit(self, "FollowState")
	pass
