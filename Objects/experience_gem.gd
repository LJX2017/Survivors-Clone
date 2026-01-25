extends Area2D

@export var experience: int = 1
@onready var sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")

signal pickup(experience: int)

var speed: float = -2.0
var target: Node2D = null
var thresh: float = 5.0

func _ready() -> void:
	if experience < 5:
		sprite.play("green")
	elif experience < 20:
		sprite.play("blue")
	else:
		sprite.play("red")


func _physics_process(delta: float) -> void:
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 5 * delta
		if global_position.distance_to(target.global_position) <= thresh:
			emit_signal("pickup", experience)
			queue_free()
