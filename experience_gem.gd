extends Area2D

var target: Node2D = null
@export var experience: int = 1
@onready var animated_sprite = get_node("AnimatedSprite2D")
var speed = 0
var thresh: float = 5.0

signal pickup(experience: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("gems")
	if experience < 5:
		animated_sprite.play("green")
	elif experience < 25:
		animated_sprite.play("blue")
	else:
		animated_sprite.play("red")


func _physics_process(delta: float) -> void:
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 2*delta
		if (global_position.distance_to(target.global_position) <= thresh):
			emit_signal("pickup", experience)
			queue_free()
