extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -550.0

var direction: int = 1  # 1 for right, -1 for left
var player: Node2D  # Reference to the player node

func _ready():
    player = get_parent().get_node("Player") as Node2D

func _physics_process(delta):
    # Add the gravity.
    if not is_on_floor():
        velocity += get_gravity() * delta

    if is_on_floor() and is_on_wall():
        velocity.y = JUMP_VELOCITY

    var direction : Vector2 = Vector2.ZERO
    if floor(global_position.distance_to(player.global_position)) as int < LevelGlobals.TILE_SIZE * 5:
        direction = (player.global_position - global_position).normalized()

    print(floor(global_position.distance_to(player.global_position)))

    velocity.x = direction.x * SPEED

    #$Sprite.scale.x = clamp(direction.x, -1, 1)

    move_and_slide()
