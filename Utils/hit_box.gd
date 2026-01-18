extends Area2D

var knockback_amount: float = 40
var damage: float = 2
@onready var collision = $CollisionShape2D
@onready var disable_timer = $DisableTimer

var direction: Vector2 = Vector2.ZERO

func temp_disable():
	collision.set_deferred("disabled", true)
	disable_timer.start()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_disable_timer_timeout() -> void:
	collision.set_deferred("disabled", false)
