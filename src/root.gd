extends Node

@onready var level0 = preload("res://src/level_0.tscn")

func _ready() -> void:
    LevelGlobals.projectile_container = $ProjectileContainer

    LevelGlobals.camera = $Camera

    start_level()

func start_level():
    var level = level0.instantiate()
    add_child(level)

    LevelGlobals.players.clear()
    LevelGlobals.players.push_back(level.get_node("Player"))
