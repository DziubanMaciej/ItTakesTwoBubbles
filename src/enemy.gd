extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -550.0

var player: Node2D  # Reference to the player node

func _ready():
    pass

func _physics_process(delta):
    # Add the gravity.
    if not is_on_floor():
        velocity += get_gravity() * delta

    if is_on_floor() and is_on_wall():
        velocity.y = JUMP_VELOCITY

    var distance : int = 0
    var maybe_direction : Vector2 = Vector2.ZERO
    for p in LevelGlobals.players:
        var d : int = floor(global_position.distance_to(p.global_position)) as int
        if d < distance:
            distance = d
            maybe_direction = (player.global_position - global_position).normalized()

    var direction : Vector2 = Vector2.ZERO
    if distance < LevelGlobals.TILE_SIZE * 5:
        direction = maybe_direction

    velocity.x = direction.x * SPEED

    #$Sprite.scale.x = clamp(direction.x, -1, 1)

    move_and_slide()
