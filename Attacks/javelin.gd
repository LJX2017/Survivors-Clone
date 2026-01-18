extends Node2D


@export var speed: float = 300.0
@export var return_time = 5
@export var damage: float = 2
@export var knockback_amount = 150
@onready var hit_box = get_node("hit_box")
@onready var return_timer = get_node("return_timer")

var direction = Vector2.RIGHT

var is_return = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation = direction.angle()
	hit_box.direction = direction
	hit_box.knockback_amount = knockback_amount
	hit_box.damage = damage
	return_timer.wait_time = return_time
	return_timer.start()
	

func _physics_process(delta: float):
	position += direction * speed * delta

#func _on_hit_box_area_entered(area: Area2D) -> void:
	#if area.is_in_group("hurt_box"):
		#pierce -= 1
		#if pierce <= 0:
			#queue_free()


func _on_return_timer_timeout() -> void:
	pass # Replace with function body.
