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
					enemy_spawn.global_position = get_random_position()
					add_child(enemy_spawn)


func get_random_position() -> Vector2:
	var vpr = get_viewport_rect().size * 1.2
	var top_left = Vector2(player.global_position.x - vpr.x/2,
							player.global_position.y - vpr.y/2,)
	var top_right = Vector2(player.global_position.x + vpr.x/2,
							player.global_position.y - vpr.y/2,)
	var bottom_left = Vector2(player.global_position.x - vpr.x/2,
							player.global_position.y + vpr.y/2,)
	var bottom_right = Vector2(player.global_position.x + vpr.x/2,
							player.global_position.y + vpr.y/2,)
	var spawn_position = ["up", "down", "left", "right"].pick_random()
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	match spawn_position:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right
	
	return Vector2(
		randf_range(spawn_pos1.x, spawn_pos2.x),
		randf_range(spawn_pos1.y, spawn_pos2.y),
	)
