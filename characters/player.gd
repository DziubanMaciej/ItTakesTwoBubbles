extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Projectile container is a parent node for each projectile. We need it to be
# relative to world, not the player.
@export var player = "player0"
var action_left = str(player, "_left")
var action_right = str(player, "_right")
var action_jump = str(player, "_jump")
var action_shoot = str(player, "_shoot")

# Flag to track if the jump button is being held
var jump_held = false

func _process(delta: float) -> void:
    pass

func _physics_process(delta: float) -> void:
    # Add the gravity.
    if not is_on_floor():
        velocity += get_gravity() * delta

    # Handle jumping
    if Input.is_action_pressed(action_jump):
        jump_held = true
    else:
        jump_held = false

    # Jump when on the floor and the jump button is held
    if is_on_floor() and jump_held:
        velocity.y = JUMP_VELOCITY

    # Handle horizontal movement
    var direction := Input.get_axis(action_left, action_right)
    if direction:
        velocity.x = direction * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)

    move_and_slide()
