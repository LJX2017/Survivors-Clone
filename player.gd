extends CharacterBody2D

var hp = 80
var speed = 40.0
var direction = Vector2.ZERO
@onready var animated_sprite = $AnimatedSprite2D

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
