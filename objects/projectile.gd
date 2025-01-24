extends Node2D

@onready var sprite = $Sprite2D

func _physics_process(delta: float) -> void:
    transform = transform.translated_local(Vector2(4, 0))
    sprite.transform = sprite.transform.rotated_local(0.07)
