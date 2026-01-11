extends CharacterBody2D

@export var hp: int = 10
@export var speed = 20.0
#@export 
var direction = Vector2.ZERO
@onready var animated_sprite = $AnimatedSprite2D
@onready var collision = $CollisionShape2D
@onready var hitbox = $hit_box
var player: Node2D

var knockback: Vector2 = Vector2.ZERO


func _ready() -> void:
	animated_sprite.play("walk")

func _physics_process(delta: float) -> void:
	movement(delta)
	update_animation()

func movement(delta: float):
	direction = player.global_position - global_position
	direction = direction.normalized()
	velocity = direction * speed
	#if knockback != Vector2.ZERO:
		#knockback.move_toward(Vector2.ZERO, kno)
	move_and_collide(velocity * delta)

func update_animation():
	if direction.x > 0:
		animated_sprite.flip_h = true
	elif direction.x < 0:
		animated_sprite.flip_h = false


func _on_hurt_box_hurt(damage: float, knockback_direction: Vector2, knockback_amount: float) -> void:
	hp -= damage
	if hp <= 0:
		animated_sprite.play("explode")
		collision_layer = 0
		collision_mask = 0
		set_physics_process(false)
		collision.set_deferred("disabled", true)
		hitbox.set_deferred("disable_mode", true)
		await animated_sprite.animation_finished
		queue_free()
	knockback = knockback_direction * knockback_amount
