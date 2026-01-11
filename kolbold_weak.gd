extends CharacterBody2D

@export var hp: int = 10
@export var knockback_recovery = 3.5
@export var speed = 20.0
var direction = Vector2.ZERO
@onready var animated_sprite = $AnimatedSprite2D
var player: Node2D
var knockback: Vector2

func _physics_process(delta: float) -> void:
	movement(delta)
	update_animation()

func movement(delta: float):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	direction = player.global_position - global_position
	direction = direction.normalized()
	velocity = direction * speed
	velocity += knockback
	animated_sprite.play("walk")
	move_and_slide()

func update_animation():
	if direction.x > 0:
		animated_sprite.flip_h = true
	elif direction.x < 0:
		animated_sprite.flip_h = false


func _on_hurt_box_hurt(damage: float, knockback_direction: Vector2, knockback_amount: float) -> void:
	hp -= damage
	if hp <= 0:
		animated_sprite.play("explode")
		set_physics_process(false)
		
		await animated_sprite.animation_finished
		queue_free()
	knockback = knockback_amount * knockback_direction
	
