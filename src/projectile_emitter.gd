extends Node2D

class_name ProjectileEmitter

enum Type {
    None,
    Horizontal,
    Aimed,
}

@export var min_timeout : float = 2.5
@export var max_timeout : float = 5
@export var type := Type.Horizontal

@onready var scene_projectile = preload("res://src/projectile.tscn")

var rng = RandomNumberGenerator.new()

func _ready() -> void:
    setup_timer()

func setup_timer():
    var timeout = rng.randf_range(min_timeout, max_timeout)
    $Timer.start(timeout)

func _on_timer_timeout() -> void:
    setup_timer()

    if LevelGlobals.players.is_empty():
        return

    if type == Type.None:
        return

    var projectile = scene_projectile.instantiate()
    LevelGlobals.projectile_container.add_child(projectile)
    projectile.global_position = global_position
    projectile.set_projectile_type(Projectile.ProjectileType.Enemy)

    match type:
        Type.Horizontal:
            projectile.set_direction_left()
        Type.Aimed:
            var player_position = get_random_player_position()
            var direction = global_position.direction_to(player_position)
            projectile.set_direction(direction)

func get_random_player_position() -> Vector2:
    var player_index = randi_range(0, LevelGlobals.players.size() - 1)
    var player = LevelGlobals.players[player_index]
    return player.global_position
