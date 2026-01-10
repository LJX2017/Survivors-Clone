extends Node2D

@export var spawns: Array[Spawn_info] = []

@onready var player = %player

@export var time: int = 0


func _on_timer_timeout() -> void:
	time += 1
	var enemy_spawns = spawns
	for i in enemy_spawns:
		if i.time_start <= time and time <= i.time_end:
			if i.spawn_delay_counter < i.enemy_spawn_delay:
				i.spawn_delay_counter += 1
			else:
				i.spawn_delay_counter = 0
				var new_enemy = i.enemy
				for j in range(i.enemy_num):
					var enemy_spawn = new_enemy.instantiate()
					enemy_spawn.player = player
					enemy_spawn.global_position = Vector2.ZERO
					add_child(enemy_spawn)
