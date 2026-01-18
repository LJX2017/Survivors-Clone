extends Node2D


@export var speed: float = 300.0
@export var return_time = 5
@export var damage: float = 2
@export var knockback_amount = 150
@onready var hit_box = get_node("hit_box")
@onready var return_timer = get_node("return_timer")
@onready var animated_sprite:AnimatedSprite2D = get_node("AnimatedSprite2D")

var direction = Vector2.RIGHT

var thresh: float = 0.5

var return_target: Node2D = null

var is_return = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite.play("attack")
	rotation = direction.angle()
	hit_box.direction = direction
	hit_box.knockback_amount = knockback_amount
	hit_box.damage = damage
	return_timer.wait_time = return_time
	return_timer.start()

func _physics_process(delta: float):
	if !is_return:
		position += direction * speed * delta
	else:
		direction = (return_target.global_position - global_position).normalized()
		hit_box.direction = direction
		position += direction * speed * delta
		if (position.distance_squared_to(return_target.global_position) < thresh):
			queue_free()
		

func _on_return_timer_timeout() -> void:
	is_return = true
