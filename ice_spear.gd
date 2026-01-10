extends Area2D

@export var attack_size = 1.0

@export var speed = 300.0
@export var pierce = 1
@export var lifetime = 2.5
@export var debug_prints = true
var direction = Vector2.RIGHT

@onready var hit_box: Area2D = get_node("hit_box")
@onready var lifetime_timer: Timer = get_node("lifetime_timer")

func _ready() -> void:
	rotation = direction.angle()
	hit_box.area_entered.connect(_on_hit_box_area_entered)
	lifetime_timer.wait_time = lifetime
	lifetime_timer.start()
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1,1)*attack_size,1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	
func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_hit_box_area_entered(area: Area2D) -> void:
	if debug_prints:
		print("Ice spear hit. area=", area)
	if area.is_in_group("hurtbox"):
		pierce -= 1
		if pierce <= 0:
			if debug_prints:
				print("Ice spear destroyed after hit.")
			queue_free()

func _on_lifetime_timer_timeout() -> void:
	if debug_prints:
		print("Ice spear lifetime ended.")
	queue_free()
