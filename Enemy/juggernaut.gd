extends CharacterBody2D

@export var hp: float = 100
@export var attack_damage: float = 5
@export var speed: float = 10
@export var knockback_recovery = 15
@export var gem_scene: PackedScene
@export var experience_drop: int = 30
var direction = Vector2.ZERO
@onready var animated_sprite = $AnimatedSprite2D
@onready var collision = $CollisionShape2D
@onready var hitbox = $hit_box
@onready var hurtbox = $hurt_box
var player: Node2D = null

var knockback: Vector2 = Vector2.ZERO


func _ready() -> void:
	if not hurtbox.is_connected("hurt", _on_hurt_box_hurt):
		hurtbox.connect("hurt", _on_hurt_box_hurt)
	hitbox.damage = attack_damage
	animated_sprite.play("walk")

func _physics_process(delta: float) -> void:
	movement(delta)
	update_animation()

func movement(delta: float):
	direction = player.global_position - global_position
	direction = direction.normalized()
	velocity = direction * speed
	if knockback != Vector2.ZERO:
		knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
		velocity += knockback
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
		var gem = gem_scene.instantiate()
		gem.experience = experience_drop
		gem.global_position = global_position
		get_parent().add_child(gem)
		queue_free()
	knockback = knockback_direction * knockback_amount
