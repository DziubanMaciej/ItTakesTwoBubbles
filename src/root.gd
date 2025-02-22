extends Node

class_name Root

@onready var levels := [
    preload("res://src/level_0.tscn"),
    preload("res://src/level_1.tscn"),
]

var level_index = 0
var current_level = null

func _ready() -> void:
    LevelGlobals.projectile_container = $ProjectileContainer
    LevelGlobals.camera = $Camera
    LevelGlobals.root = self

    start_level()

func get_current_level_scene():
    level_index %= levels.size()
    return levels[level_index]

func start_level():
    if current_level != null:
        current_level.queue_free()
        for child in $ProjectileContainer.get_children():
            child.queue_free()

    current_level = get_current_level_scene().instantiate()
    add_child(current_level)

    LevelGlobals.players.clear()
    LevelGlobals.players.push_back(current_level.get_node("Player0"))
    LevelGlobals.players.push_back(current_level.get_node("Player1"))

    for n in current_level.get_children():
        if "Enemy".to_lower() in n.name.to_lower():
            LevelGlobals.enemies.push_back(n)

func start_next_level():
    level_index += 1
    start_level()

func _process(delta: float) -> void:
    if Input.is_action_just_pressed("reset_level"):
        start_level()
