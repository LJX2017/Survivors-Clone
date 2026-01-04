extends CharacterBody2D


var speed = 40.0
var direction = Vector2.ZERO

func _physics_process(delta: float) -> void:
	movement(delta)

func movement(delta: float):
	direction = Vector2(Input.get_axis("left", "right"),
	Input.get_axis("up", "down"))
	direction = direction.normalized()
	velocity = direction * speed
	move_and_collide(velocity * delta)
