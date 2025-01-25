extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
    var player := body as CharacterBody2D
    if player:
        LevelGlobals.root.start_next_level()
