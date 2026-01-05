extends Area2D

@export_enum("Cooldown", "DisableHitbox") var HurtBoxType: int

@onready var collision = $CollisionShape2D

signal(hurt, damage)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("damage"):
		if area.get("damage") != null:
			match HurtBoxType:
				0:
					collision.set_deferred("disabled", true)
				1:
					if area.has_method("temp_disable"):
						area.temp_disable()
			emit_signal("hurt", area.damage)
