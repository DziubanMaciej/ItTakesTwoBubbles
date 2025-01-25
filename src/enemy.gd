extends Node2D

enum AiType {
    Stationary,
    UpDown,
}

enum Model {
    Model1,
    Model2
}

@export var shoot_type := ProjectileEmitter.Type.Horizontal
@export var ai_type := AiType.Stationary
@export var model := Model.Model1

func _ready() -> void:
    $Root/ProjectileEmitter.type = shoot_type

    match ai_type:
        AiType.Stationary:
            pass
        AiType.UpDown:
            $Root/MovementAnimation.play("patrol_up")

    match model:
        Model.Model1:
            $Root/Sprite2D.region_rect.position = Vector2(263, -11)
        Model.Model2:
            $Root/Sprite2D.region_rect.position = Vector2(90, 243)

func take_damage(amount: int) -> void:
    # TODO enemy health
    die()

func die():
    queue_free()
