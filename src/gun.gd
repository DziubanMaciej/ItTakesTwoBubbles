extends Node2D

@onready var muzzle: Marker2D = $Marker2D
@onready var scene_projectile = preload("res://src/projectile.tscn")

@export var projectile_container: Node2D
@export var player = "player0"
var action_fire = str(player, "_fire")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    look_at(get_global_mouse_position())

    rotation_degrees = wrap(rotation_degrees, 0, 360)
    if rotation_degrees > 90 and rotation_degrees < 270:
        scale.y = -.5
    else:
        scale.y = .5

    if Input.is_action_just_pressed(action_fire):
        var bullet_instance = scene_projectile.instantiate()
        get_tree().root.add_child(bullet_instance)
        bullet_instance.global_position = muzzle.global_position
        bullet_instance.rotation = rotation
        bullet_instance.enable_enemy_collision()
