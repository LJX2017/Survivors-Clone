extends Node2D

@export var max_distance: float = 200.0
@export var speed: float = 320.0
@export var damage: float = 1.0
@export var knockback_amount: float = 120.0
@export var return_snap_distance: float = 6.0
@export var attack_texture: Texture2D

@onready var sprite = $Sprite2D
@onready var hit_box = $hit_box

var player: Node2D = null
var direction: Vector2 = Vector2.RIGHT
var origin_position: Vector2 = Vector2.ZERO
var returning: bool = false

func _ready() -> void:
	origin_position = global_position
	hit_box.damage = damage
	hit_box.knockback_amount = knockback_amount
	hit_box.hit_once_per_hurtbox = true
	_set_flight_visual()

func _physics_process(delta: float) -> void:
	if player == null:
		queue_free()
		return
	if returning:
		_move_to(player.global_position, delta)
		if global_position.distance_to(player.global_position) <= return_snap_distance:
			queue_free()
		return
	_move_to(origin_position + direction * max_distance * 1.1, delta)
	if global_position.distance_to(origin_position) >= max_distance:
		returning = true

func _move_to(target: Vector2, delta: float) -> void:
	global_position = global_position.move_toward(target, speed * delta)
	rotation = direction.angle()

func _set_flight_visual() -> void:
	if attack_texture != null:
		sprite.texture = attack_texture
	hit_box.monitoring = true
