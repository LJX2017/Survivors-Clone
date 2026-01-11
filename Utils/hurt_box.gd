extends Area2D

@export_enum("Cooldown", "DisableHitbox") var HurtBoxType: int

@onready var collision = $CollisionShape2D
@onready var disable_timer = $DisableTimer
signal hurt(damage: float, knockback_direction: Vector2, knockback_amount: float)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("damage"):
		if area.get("damage") != null:
			match HurtBoxType:
				0:
					collision.set_deferred("disabled", true)
					disable_timer.start()
				1:
					if area.has_method("temp_disable"):
						area.temp_disable()
			var knockback_direction := Vector2.ZERO
			if area.get("knockback_direction") != null:
				knockback_direction = area.knockback_direction
			var knockback_amount := 0.0
			if area.get("knockback_amount") != null:
				knockback_amount = area.knockback_amount
			emit_signal("hurt", area.damage, knockback_direction, knockback_amount)



func _on_disable_timer_timeout() -> void:
	collision.set_deferred("disabled", false)
