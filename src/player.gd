extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -750.0
const FORCE_DOWN_VELOCITY = 890.0
const DEFAULT_MAX_HEALTH = 5
const HEAL_DELAY = 15.0

@onready var health_bar = $HealthBar
@onready var heal_timer = Timer.new()
@export var player_index := 0

@onready var action_left = str("player", player_index, "_left")
@onready var action_right = str("player", player_index, "_right")
@onready var action_jump = str("player", player_index, "_jump")
@onready var action_down = str("player", player_index, "_down")
@onready var action_fire = str("player", player_index, "_fire")

# Flag to track if the jump button is being held
var jump_held = false
@onready var initial_scale = $Sprite2D.scale
var last_velocity_x_direction = 1.

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
    $GunMarker/Gun.set_player_index(player_index)

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

    LevelGlobals.root.start_level()

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

    if not is_on_floor() and Input.is_action_pressed(action_down):
        velocity.y = FORCE_DOWN_VELOCITY

    # Handle horizontal movement
    var direction := Input.get_axis(action_left, action_right)
    if direction:
        velocity.x = direction * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)

    # Shoot
    if Input.is_action_just_pressed(action_fire):
        $GunMarker/Gun.shoot()

    # Update animation
    if velocity.x == 0:
        $Sprite2D/AnimationPlayer.stop()
    else:
        last_velocity_x_direction = velocity.x
        if not $Sprite2D/AnimationPlayer.is_playing():
            $Sprite2D/AnimationPlayer.play("Walk")
    var dst_scale = -initial_scale.x if last_velocity_x_direction < 0 else initial_scale.x
    $Sprite2D.scale.x = lerp($Sprite2D.scale.x, dst_scale, 0.3)

    move_and_slide()
