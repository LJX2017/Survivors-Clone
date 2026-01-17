extends Node2D

@export var radius: float = 48.0
@export var angular_speed: float = 3.0
@export var lifetime: float = 5.0
@export var damage: float = 30

@onready var hit_box = get_node("hit_box")
@onready var lifetime_timer = get_node("lifetime_timer")

var direction: Vector2 = Vector2.RIGHT
var center: Node2D = null
var _angle: float = 0.0
var _rng := RandomNumberGenerator.new()
var _prev_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	_rng.randomize()
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT.rotated(_rng.randf_range(0.0, TAU))
	_angle = direction.angle()
	_prev_position = global_position
	hit_box.damage = damage
	lifetime_timer.wait_time = lifetime
	lifetime_timer.start()

func _physics_process(delta: float) -> void:
	if center == null or not is_instance_valid(center):
		queue_free()
		return
	_angle += angular_speed * delta
	var new_position = center.global_position + Vector2(radius, 0).rotated(_angle)
	global_position = new_position
	var velocity = (new_position - _prev_position) / max(delta, 0.0001)
	_prev_position = new_position
	if velocity.length_squared() > 0.001:
		hit_box.direction = velocity.normalized()

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("hurt_box"):
		pass

func _on_lifetime_timer_timeout() -> void:
	queue_free()
