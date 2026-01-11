extends CharacterBody2D

@export var hp: int = 10

@export var speed = 20.0
var direction = Vector2.ZERO
@onready var animated_sprite = $AnimatedSprite2D
var player: Node2D
var knockback_direction
var knockback_amount

func _physics_process(delta: float) -> void:
	movement(delta)
	update_animation()

func movement(delta: float):
	direction = player.global_position - global_position
	direction = direction.normalized()
	velocity = direction * speed
	animated_sprite.play("walk")
	move_and_collide(velocity * delta)

func update_animation():
	if direction.x > 0:
		animated_sprite.flip_h = true
	elif direction.x < 0:
		animated_sprite.flip_h = false


func _on_hurt_box_hurt(damage: float, knockback_direction: Vector2, knockback_amount: float) -> void:
	hp -= damage
	if hp <= 0:
		queue_free()
