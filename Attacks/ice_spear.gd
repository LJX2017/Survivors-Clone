extends Node2D


@export var speed: float = 300.0
@export var pierce: int = 1
@export var lifetime = 5
@onready var hit_box = get_node("hit_box")
@onready var lifetime_timer = get_node("lifetime_timer")

var direction = Vector2.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hit_box.area_entered.connect(_on_hit_box_area_entered)
	lifetime_timer.wait_time = lifetime
	lifetime_timer.start()
	

func _physics_process(delta: float):
	position += direction * speed * delta

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("hurt_box"):
		pierce -= 1
		if pierce <= 0:
			queue_free()

func _on_lifetime_timer_timeout() -> void:
	queue_free()
