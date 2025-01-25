extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DEFAULT_MAX_HEALTH = 5
const HEAL_DELAY = 15.0

@onready var health_bar = $HealthBar
@onready var heal_timer = Timer.new()
@export var player = "player0"

var action_left = str(player, "_left")
var action_right = str(player, "_right")
var action_jump = str(player, "_jump")
var action_shoot = str(player, "_shoot")

# Flag to track if the jump button is being held
var jump_held = false

func _ready() -> void:
    health_bar.update_health_bar()
    add_child(heal_timer)  # Add the timer to the scene
    heal_timer.wait_time = HEAL_DELAY
    heal_timer.one_shot = false
    heal_timer.connect("timeout", Callable(self, "_on_heal_timer_timeout"))
    heal_timer.start()
    health_bar.max_health = 8
    health_bar.current_health = 8

    $CameraSetter.remote_path = LevelGlobals.camera.get_path()

func take_damage(amount: int) -> void:
    health_bar.take_damage(amount)
    heal_timer.start()

    if health_bar.current_health == 0:
        die()

func _on_heal_timer_timeout() -> void:
    # Heal the player by 1 health point if not at max health
    if health_bar.current_health < health_bar.max_health:
        heal(1)
        print("Player healed by 1!")

func heal(amount: int) -> void:
    health_bar.heal(amount)
    health_bar.update_health_bar()

func increase_max_health(amount: int) -> void:
    health_bar.max_health += amount
    health_bar.current_health = health_bar.max_health
    health_bar.update_health_bar()

func die() -> void:
    LevelGlobals.players.erase(self)

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
