extends Node2D

signal unlock
signal lock

var objective_count = 0


func _ready() -> void:
	unlock_room()


func add_objective() -> void:
	objective_count += 1
	
	print("Objective added. Total: " + str(objective_count))


func remove_objective() -> void:
	objective_count -= 1
	
	if objective_count == 0:
		unlock_room()


func lock_room() -> void:
	if objective_count > 0:
		lock.emit()


func unlock_room() -> void:
	unlock.emit()
