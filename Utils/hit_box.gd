extends Area2D

@export var damage = 2
@onready var collision = $CollisionShape2D
@onready var disable_timer = $DisableTimer
@export var debug_prints = true

func _ready() -> void:
	if debug_prints:
		print("HitBox ready. layer=", collision_layer, " mask=", collision_mask, " groups=", get_groups(), " damage=", damage)

func temp_disable():
	collision.set_deferred("disabled", true)
	disable_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_disable_timer_timeout() -> void:
	collision.set_deferred("disabled", false)
