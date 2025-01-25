extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DEFAULT_MAX_HEALTH = 5

# Projectile container is a parent node for each projectile. We need it to be
# relative to world, not the player.

@onready var bubble_image = preload("res://objects/buble.png")
@onready var health_bar = $HealthBarCanvas/HealthBar
@export var player = "player0"

var action_left = str(player, "_left")
var action_right = str(player, "_right")
var action_jump = str(player, "_jump")
var action_shoot = str(player, "_shoot")

# Flag to track if the jump button is being held
var jump_held = false
var max_health = DEFAULT_MAX_HEALTH
var current_health = DEFAULT_MAX_HEALTH

func _ready() -> void:
    update_health_bar()
    
func update_health_bar() -> void:
    # add/remove health based on max health
    while health_bar.get_child_count() < max_health:
        var bubble = TextureRect.new()
        bubble.texture = bubble_image
        bubble.visible = true
        health_bar.add_child(bubble)

    while health_bar.get_child_count() > max_health:
        health_bar.get_child(health_bar.get_child_count() - 1).queue_free()

    # Update visibility of bubles
    for i in range(max_health):
        health_bar.get_child(i).visible = i < current_health

func take_damage(amount: int) -> void:
    current_health -= amount
    current_health = clamp(current_health, 0, max_health)
    update_health_bar()
    
    if current_health == 0:
        die()
        
func heal(amount: int) -> void:
    current_health += amount
    current_health = clamp(current_health, 0, max_health)
    update_health_bar()

func increase_max_health(amount: int) -> void:
    max_health += amount
    current_health = max_health
    update_health_bar()
    
func die() -> void:
    print("Player died!")
    queue_free()

func _process(_delta: float) -> void:
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
