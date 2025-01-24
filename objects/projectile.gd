extends Node2D

@onready var sprite = $Sprite2D

var direction = Vector2(1, 0)
var move_speed = 20

func set_direction_right():
    direction.x = 1

func set_direction_left():
    direction.x = -1

func _physics_process(delta: float) -> void:
    transform = transform.translated_local(direction * move_speed)
    sprite.transform = sprite.transform.rotated_local(0.07)
