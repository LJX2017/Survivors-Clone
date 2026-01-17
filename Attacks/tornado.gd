extends Node2D

@export var radius: float = 50.0
@export var angular_speed: float = 3
@export var lifetime: float = 2
@export var damage: float = 2

@onready var hit_box = get_node('hit_box')
@onready var lifetime_timer = get_node("lifetime_timer")

var prev_position: Vector2 = Vector2.ZERO
var angle: float = 0
var center: Node2D = null
var direction: Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	prev_position = global_position
	lifetime_timer.wait_time = lifetime
	lifetime_timer.start()

func _physics_process(delta: float) -> void:
	if center == null:
		queue_free()
	angle += angular_speed * delta
	var new_position = center.global_position + Vector2(radius, 0).rotated(angle)
	global_position = new_position
	prev_position = global_position
	direction = (new_position - prev_position).normalized()
	hit_box.direction = direction


func _on_lifetime_timer_timeout() -> void:
	queue_free()
