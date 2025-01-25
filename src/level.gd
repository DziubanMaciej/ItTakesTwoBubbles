extends Node

func _ready() -> void:
    LevelGlobals.projectile_container = $ProjectileContainer

    LevelGlobals.players.clear()
    LevelGlobals.players.push_back($Player)
