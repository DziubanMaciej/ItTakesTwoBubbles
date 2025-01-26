extends CharacterBody2D

const SPEED : float = 300.0
const JUMP_VELOCITY : float = -550.0

var health : float = 100.0

func _ready():
    pass

func take_damage(amount: int) -> void:
    health -= 10.0

func _physics_process(delta):
    if not is_on_floor():
        velocity += get_gravity() * delta

    if is_on_floor() and is_on_wall():
        velocity.y = JUMP_VELOCITY

    var distance : float = INF
    var direction : Vector2 = Vector2.ZERO
 
    for p in LevelGlobals.players:
        var d : float = global_position.distance_to(p.global_position)

        if d < distance:
            distance = d

            if distance < LevelGlobals.TILE_SIZE * 10:
                direction = (p.global_position - global_position).normalized()
            else:
                direction = Vector2.ZERO

    velocity.x = direction.x * SPEED

    if health <= 0.0:
        print("{} died!" % [self])
        queue_free()

    # TODO(milliewaly): Looks cool!
    #$Sprite.scale.x = clamp(direction.x, -1, 1)

    move_and_slide()
