extends CharacterBody2D


@export var speed = 20.0
var direction = Vector2.ZERO

func _physics_process(delta: float) -> void:
	movement()

func movement():
	direction = %player.global_position - global_position
	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()
