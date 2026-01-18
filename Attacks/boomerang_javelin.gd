extends Node2D

@export var throw_interval: float = 2.5
@export var max_distance: float = 200.0
@export var speed: float = 320.0
@export var damage: float = 1.0
@export var knockback_amount: float = 120.0
@export var rest_offset: Vector2 = Vector2(14, -6)
@export var idle_texture: Texture2D
@export var attack_texture: Texture2D
@export var attack_modulate: Color = Color(0.45, 0.7, 1.0, 1.0)

@onready var sprite = $Sprite2D
@onready var hit_box = $hit_box
@onready var throw_timer = $throw_timer

var player: Node2D = null
var direction: Vector2 = Vector2.RIGHT
var origin_position: Vector2 = Vector2.ZERO
var returning: bool = false
var hurtboxes_hit: Dictionary[int, bool] = {}

func _ready() -> void:
	throw_timer.wait_time = throw_interval
	throw_timer.one_shot = true
	throw_timer.start()
	hit_box.damage = damage
	hit_box.knockback_amount = knockback_amount
	_set_resting_visual()

func _physics_process(delta: float) -> void:
	if player == null:
		queue_free()
		return
	if throw_timer.is_stopped() and not returning:
		_start_throw()
	if returning:
		_move_to(player.global_position, delta)
		if global_position.distance_to(player.global_position) <= 6.0:
			_finish_return()
		return
	if throw_timer.is_stopped():
		_move_to(origin_position + direction * max_distance, delta)
		if global_position.distance_to(origin_position) >= max_distance:
			returning = true
			return
		return
	global_position = player.global_position + rest_offset

func _on_throw_timer_timeout() -> void:
	pass

func _on_hit_box_area_entered(area: Area2D) -> void:
	if not area.is_in_group("hurt_box"):
		return
	var hurtbox_id: int = area.get_instance_id()
	if hurtboxes_hit.has(hurtbox_id):
		return
	hurtboxes_hit[hurtbox_id] = true

func _start_throw() -> void:
	origin_position = player.global_position
	direction = _get_throw_direction()
	returning = false
	hurtboxes_hit.clear()
	_set_flight_visual()

func _finish_return() -> void:
	returning = false
	_set_resting_visual()
	throw_timer.start()

func _move_to(target: Vector2, delta: float) -> void:
	global_position = global_position.move_toward(target, speed * delta)
	rotation = direction.angle()

func _get_throw_direction() -> Vector2:
	var aim := Vector2.RIGHT
	if player.has_method("get_nearest_enemy"):
		var target: Node2D = player.get_nearest_enemy()
		if target != null:
			aim = (target.global_position - origin_position).normalized()
	if aim == Vector2.ZERO and player.get("direction") != null:
		if player.direction != Vector2.ZERO:
			aim = player.direction.normalized()
	return aim

func _set_resting_visual() -> void:
	if idle_texture != null:
		sprite.texture = idle_texture
	sprite.modulate = Color(1, 1, 1, 1)
	hit_box.monitoring = false

func _set_flight_visual() -> void:
	if attack_texture != null:
		sprite.texture = attack_texture
	sprite.modulate = attack_modulate
	hit_box.monitoring = true
