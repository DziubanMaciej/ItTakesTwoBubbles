extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Projectile container is a parent node for each projectile. We need it to be
# relative to world, not the player.
@export var projectile_container : Node2D

@export var player = "player0"
var action_left = str(player, "_left")
var action_right = str(player, "_right")
var action_jump = str(player, "_jump")
var action_shoot = str(player, "_shoot")

@onready var scene_projectile = preload("res://objects/projectile.tscn")

func _process(delta: float) -> void:
    if Input.is_action_just_pressed(action_shoot):
        var projectile = scene_projectile.instantiate()
        projectile_container.add_child(projectile)
        projectile.global_position = $Emitter.global_position

func _physics_process(delta: float) -> void:
    # Add the gravity.
    if not is_on_floor():
        velocity += get_gravity() * delta

    # Handle jump.
    if Input.is_action_just_pressed(action_jump) and is_on_floor():
        velocity.y = JUMP_VELOCITY

    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    var direction := Input.get_axis(action_left, action_right)
    if direction:
        velocity.x = direction * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)

    move_and_slide()
