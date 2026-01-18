extends Area2D

var knockback_amount: float = 40
var damage: float = 2
@export var hit_once_per_hurtbox: bool = false
@onready var collision = $CollisionShape2D
@onready var disable_timer = $DisableTimer

var direction: Vector2 = Vector2.ZERO
var _hurtboxes_hit: Dictionary[int, bool] = {}

func temp_disable():
	collision.set_deferred("disabled", true)
	disable_timer.start()

func can_hit_hurtbox(hurtbox: Area2D) -> bool:
	if not hit_once_per_hurtbox:
		return true
	var hurtbox_id: int = hurtbox.get_instance_id()
	if _hurtboxes_hit.has(hurtbox_id):
		return false
	_hurtboxes_hit[hurtbox_id] = true
	return true

func reset_hurtbox_hits() -> void:
	_hurtboxes_hit.clear()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_disable_timer_timeout() -> void:
	collision.set_deferred("disabled", false)
