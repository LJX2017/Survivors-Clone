extends CharacterBody2D

var hp = 80
var speed = 40.0
var direction = Vector2.ZERO
@export var ice_spear_scene: PackedScene


@onready var animated_sprite = $AnimatedSprite2D
@onready var ice_spear_timer = $ice_spear_timer

func _physics_process(delta: float) -> void:
	movement(delta)
	update_animation()

func movement(delta: float):
	direction = Vector2(Input.get_axis("left", "right"),
	Input.get_axis("up", "down"))
	direction = direction.normalized()
	velocity = direction * speed
	move_and_collide(velocity * delta)
	
func update_animation():
	if direction != Vector2.ZERO:
		animated_sprite.play("walk")
	else:
		animated_sprite.stop()
	if direction.x > 0:
		animated_sprite.flip_h = true
	elif direction.x < 0:
		animated_sprite.flip_h = false


func _on_hurt_box_hurt(damage: Variant) -> void:
	hp -= damage
	print(hp)


func _on_ice_spear_timer_timeout() -> void:
	if ice_spear_scene == null:
		print("ice_spear_scene is null")
		return
	var spear: Node2D = ice_spear_scene.instantiate()
	var target = get_nearest_enemy()
	var aim_direction = Vector2.RIGHT
	if target != null:
		aim_direction = (target.global_position - global_position).normalized()
	spear.global_position = global_position
	spear.direction = aim_direction
	get_parent().add_child(spear)
	ice_spear_timer.start()
	
func get_nearest_enemy() -> Node2D:
	var nearest: Node2D = null
	var nearest_distance = INF
	var world_rect = get_viewport_world_rect()
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if enemy is Node2D:
			if world_rect != null and not world_rect.has_point(enemy.global_position):
				continue
			var distance = global_position.distance_squared_to(enemy.global_position)
			if distance < nearest_distance:
				nearest_distance = distance
				nearest = enemy
	return nearest

func get_viewport_world_rect() -> Rect2:
	var vp := get_viewport()
	var cam := vp.get_camera_2d()
	if cam == null:
		return Rect2(vp.get_visible_rect())
	var size := vp.get_visible_rect().size * cam.zoom
	var top_left := cam.global_position - size * 0.5
	return Rect2(top_left, size)
