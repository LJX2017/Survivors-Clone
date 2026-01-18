extends Area2D

@export_enum("Cooldown", "DisableHitbox", "HitOnceCountdown") var HurtBoxType: int
@export var hit_once_cooldown: float = 0.25

@onready var collision = $CollisionShape2D
@onready var disable_timer = $DisableTimer
signal hurt(damage: float, knockback_direction: Vector2, knockback_amount: float)
var _last_hit_msec_by_hitbox: Dictionary[int, int] = {}

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("damage"):
		if area.get("damage") != null:
			if area.has_method("can_hit_hurtbox") and not area.can_hit_hurtbox(self):
				return
			match HurtBoxType:
				0:
					collision.set_deferred("disabled", true)
					disable_timer.start()
				1:
					if area.has_method("temp_disable"):
						area.temp_disable()
				2:
					var now_msec := Time.get_ticks_msec()
					var hitbox_id: int = area.get_instance_id()
					var last_hit_msec: int = _last_hit_msec_by_hitbox.get(hitbox_id, -1)
					if last_hit_msec != -1 and now_msec - last_hit_msec < int(hit_once_cooldown * 1000.0):
						return
					_last_hit_msec_by_hitbox[hitbox_id] = now_msec
			var knockback_direction = Vector2.ZERO
			var knockback_amount = 0.0
			if area.get("direction") != null:
				knockback_direction = area.direction
			if area.get("knockback_amount") != null:
				knockback_amount = area.knockback_amount
			emit_signal("hurt", area.damage, knockback_direction, knockback_amount)



func _on_disable_timer_timeout() -> void:
	collision.set_deferred("disabled", false)
