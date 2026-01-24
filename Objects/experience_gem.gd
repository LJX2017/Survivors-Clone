extends Area2D

@export var experience: int = 1
@onready var sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if experience < 5:
		sprite.play("green")
	elif experience < 20:
		sprite.play("blue")
	else:
		sprite.play("red")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
