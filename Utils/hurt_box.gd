extends Area2D

@export_enum("Cooldown", "DisableHitbox") var HurtBoxType: int

@onready var collision = $CollisionShape2D
@onready var disable_timer = $DisableTimer
signal hurt(damage)

@export var debug_prints = true

func _ready() -> void:
	if debug_prints:
		print("HurtBox ready. layer=", collision_layer, " mask=", collision_mask, " groups=", get_groups())

func _on_area_entered(area: Area2D) -> void:
	if debug_prints:
		print("HurtBox area_entered. area=", area, " area_groups=", area.get_groups())
	if area.is_in_group("damage"):
		if area.get("damage") != null:
			match HurtBoxType:
				0:
					collision.set_deferred("disabled", true)
					disable_timer.start()
				1:
					if area.has_method("temp_disable"):
						area.temp_disable()
			emit_signal("hurt", area.damage)



func _on_disable_timer_timeout() -> void:
	collision.set_deferred("disabled", false)
