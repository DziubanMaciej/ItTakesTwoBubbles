extends Node

class_name Root

@onready var level0 = preload("res://src/level_0.tscn")

var level_index = 0
var current_level = null

func _ready() -> void:
    LevelGlobals.projectile_container = $ProjectileContainer
    LevelGlobals.camera = $Camera
    LevelGlobals.root = self

    start_level()

func get_current_level_scene():
    match level_index:
        0: return level0
        _:
            print("Unknown level index. Returning level 0")
            return level0

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
