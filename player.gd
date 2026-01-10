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
	#var target = get_nearest_enemy()
	#var aim_direction = (target.global_position - global_position).normalized()
	var aim_direction = Vector2.RIGHT
	spear.global_position = global_position
	spear.direction = aim_direction
	get_parent().add_child(spear)
	ice_spear_timer.start()
	
func get_nearest_enemy() -> Node2D:
	return null
