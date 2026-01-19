extends Node2D


@export var speed: float = 300.0
@export var return_time: float = 2
@export var idle_time: float = 0.5
@export var damage: float = 2
@export var knockback_amount = 150
@onready var hit_box = get_node("hit_box")
@onready var return_timer = get_node("return_timer")
@onready var idle_timer = get_node("idle_timer")
@onready var animated_sprite:AnimatedSprite2D = get_node("AnimatedSprite2D")

var direction = Vector2.RIGHT

var thresh: float = 1

var return_target: Node2D = null


var stage = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite.play("attack")
	rotation = direction.angle()
	hit_box.direction = direction
	hit_box.knockback_amount = knockback_amount
	hit_box.damage = damage
	return_timer.wait_time = return_time
	return_timer.start()
	idle_timer.wait_time = idle_time

func _physics_process(delta: float):
	rotation = direction.angle()
	if stage == 0:
		position += direction * speed * delta
	elif stage == 1:
		direction = (return_target.global_position - global_position).normalized()
	elif stage == 2:
		direction = (return_target.global_position - global_position).normalized()
		hit_box.direction = direction
		position += direction * speed * delta
		if (position.distance_squared_to(return_target.global_position) < thresh):
			queue_free()
		

func _on_return_timer_timeout() -> void:
	if stage == 0:
		animated_sprite.play("idle")
		stage = 1
		idle_timer.start()


func _on_idle_timer_timeout() -> void:
	if stage == 1:
		stage = 2
