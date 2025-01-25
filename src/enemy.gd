extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -550.0

var player: Node2D  # Reference to the player node

func _ready():
    pass

func _physics_process(delta):
    # Add gravity.
    if not is_on_floor():
        velocity += get_gravity() * delta

    # Handle jumping when on floor and on wall.
    if is_on_floor() and is_on_wall():
        velocity.y = JUMP_VELOCITY

    var distance : float = INF  # Initialize with a very large number.
    var direction : Vector2 = Vector2.ZERO

    for p in LevelGlobals.players:
        var d : float = global_position.distance_to(p.global_position)

        # Check if this player is closer than the current closest.
        if d < distance:
            distance = d
            # Only set direction if within the desired range.
            if distance < LevelGlobals.TILE_SIZE * 10:
                direction = (p.global_position - global_position).normalized()
            else:
                direction = Vector2.ZERO  # Reset direction if out of range.

        print("%s -> %.2f, %s" % [p, d, direction])

    # Update velocity based on the direction of the closest player.
    velocity.x = direction.x * SPEED

    # Optional: Flip sprite based on direction.
    # $Sprite.scale.x = clamp(direction.x, -1, 1)

    move_and_slide()
