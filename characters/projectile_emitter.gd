extends Node2D

@export var min_timeout : float = 1
@export var max_timeout : float = 3

@export var projectile_container : Node2D
@onready var scene_projectile = preload("res://objects/projectile.tscn")

var rng = RandomNumberGenerator.new()

func _ready() -> void:
    setup_timer()

func setup_timer():
    var timeout = rng.randf_range(min_timeout, max_timeout)
    $Timer.start(timeout)

func _on_timer_timeout() -> void:
    setup_timer()

    var projectile = scene_projectile.instantiate()
    projectile_container.add_child(projectile)
    projectile.global_position = global_position
    projectile.set_direction_left()
    projectile.enable_player_collision()
