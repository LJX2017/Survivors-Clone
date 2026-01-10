extends Node2D

@export var spawns: Array[Resource] = []

@onready var player = %player

@export var time: int = 0


func _on_timer_timeout() -> void:
	pass # Create a new 
