extends Node2D

@export var projectile_container : Node2D

func _ready() -> void:
    $Enemy/ProjectileEmitter.projectile_container = projectile_container

func _physics_process(_delta: float) -> void:
    pass
    #print("PHYSICS")
