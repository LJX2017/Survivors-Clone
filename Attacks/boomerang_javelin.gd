extends Node2D

enum JavelinState { RESTING, OUTBOUND, RETURNING }

@export var throw_interval: float = 2.5
@export var max_distance: float = 200.0
@export var speed: float = 320.0
@export var damage: float = 1.0
@export var knockback_amount: float = 120.0
@export var rest_offset: Vector2 = Vector2(14, -6)
@export var return_snap_distance: float = 6.0
@export var idle_texture: Texture2D
@export var attack_texture: Texture2D
@export var attack_modulate: Color = Color(0.45, 0.7, 1.0, 1.0)

@onready var sprite = $Sprite2D
@onready var hit_box = $hit_box
@onready var throw_timer = $throw_timer

var player: Node2D = null
var _state: JavelinState = JavelinState.RESTING
var _throw_direction: Vector2 = Vector2.RIGHT
var _origin_position: Vector2 = Vector2.ZERO
var _hurtboxes_hit: Dictionary[int, bool] = {}

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
	if _state == JavelinState.RESTING:
		global_position = player.global_position + rest_offset
		return

	var target_position := _get_target_position()
	global_position = global_position.move_toward(target_position, speed * delta)
	rotation = _throw_direction.angle()
	if _state == JavelinState.OUTBOUND:
		if global_position.distance_to(_origin_position) >= max_distance:
			_start_return()
	else:
		if global_position.distance_to(player.global_position) <= return_snap_distance:
			_finish_return()

func _on_throw_timer_timeout() -> void:
	if _state != JavelinState.RESTING:
		return
	_start_throw()

func _on_hit_box_area_entered(area: Area2D) -> void:
	if not area.is_in_group("hurt_box"):
		return
	var hurtbox_id: int = area.get_instance_id()
	if _hurtboxes_hit.has(hurtbox_id):
		return
	_hurtboxes_hit[hurtbox_id] = true
	hit_box.add_collision_exception_with(area)

func _start_throw() -> void:
	_origin_position = player.global_position
	_throw_direction = _get_throw_direction()
	_state = JavelinState.OUTBOUND
	_reset_hit_cycle()
	_set_flight_visual()

func _start_return() -> void:
	_state = JavelinState.RETURNING

func _finish_return() -> void:
	_state = JavelinState.RESTING
	_set_resting_visual()
	throw_timer.start()

func _reset_hit_cycle() -> void:
	_hurtboxes_hit.clear()
	hit_box.clear_collision_exceptions()

func _get_throw_direction() -> Vector2:
	var direction := Vector2.RIGHT
	if player.has_method("get_nearest_enemy"):
		var target: Node2D = player.get_nearest_enemy()
		if target != null:
			direction = (target.global_position - _origin_position).normalized()
	if direction == Vector2.ZERO and player.get("direction") != null:
		if player.direction != Vector2.ZERO:
			direction = player.direction.normalized()
	return direction

func _get_target_position() -> Vector2:
	if _state == JavelinState.OUTBOUND:
		return _origin_position + _throw_direction * max_distance
	return player.global_position

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
