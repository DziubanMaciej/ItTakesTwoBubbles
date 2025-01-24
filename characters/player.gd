extends CharacterBody2D

func _physics_process(delta: float) -> void:
    velocity = Vector2(100, -1)

    var move_direction = Input.get_action_strength("player0_right") - Input.get_action_strength("player0_left")

    velocity.x = move_direction * 600

    move_and_slide()
