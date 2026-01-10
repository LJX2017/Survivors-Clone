extends CharacterBody2D

var hp = 80
var speed = 40.0
var direction = Vector2.ZERO
var last_nonzero_direction = Vector2.RIGHT
@export var ice_spear_scene: PackedScene
@export var ice_spear_cooldown = 1.0
@export var ice_spear_debug = true
@onready var animated_sprite = $AnimatedSprite2D
@onready var ice_spear_timer: Timer = get_node("IceSpearTimer")

func _ready() -> void:
	if not ice_spear_timer.timeout.is_connected(_on_ice_spear_timer_timeout):
		ice_spear_timer.timeout.connect(_on_ice_spear_timer_timeout)
		if ice_spear_debug:
			print("Ice spear timer signal connected at runtime.")
	ice_spear_timer.wait_time = ice_spear_cooldown
	ice_spear_timer.start()
	if ice_spear_debug:
		print("Ice spear timer started. cooldown=", ice_spear_cooldown)

func _physics_process(delta: float) -> void:
	movement(delta)
	update_animation()

func movement(delta: float):
	direction = Vector2(Input.get_axis("left", "right"),
	Input.get_axis("up", "down"))
	direction = direction.normalized()
	if direction != Vector2.ZERO:
		last_nonzero_direction = direction
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
	if ice_spear_debug:
		print("Ice spear timer timeout fired.")
	if ice_spear_scene == null:
		if ice_spear_debug:
			print("No ice_spear_scene assigned on player.")
		return
	var spear = ice_spear_scene.instantiate()
	var target = get_nearest_enemy()
	var aim_direction = last_nonzero_direction
	if target != null:
		aim_direction = (target.global_position - global_position).normalized()
	if ice_spear_debug:
		print("Spawning spear. target=", target, " aim_direction=", aim_direction)
	spear.global_position = global_position
	spear.direction = aim_direction
	get_parent().add_child(spear)
	ice_spear_timer.start()


func get_nearest_enemy() -> Node2D:
	var nearest: Node2D = null
	var nearest_distance = INF
	var enemies = get_tree().get_nodes_in_group("enemies")
	if ice_spear_debug:
		print("Enemies found:", enemies.size())
	for enemy in enemies:
		if enemy is Node2D:
			var distance = global_position.distance_squared_to(enemy.global_position)
			if distance < nearest_distance:
				nearest_distance = distance
				nearest = enemy
	return nearest
