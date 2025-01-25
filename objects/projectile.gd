extends Node2D

@onready var sprite = $Sprite2D

var direction = Vector2(1, 0)
var move_speed = 20

const player_layer_index = 2 # No way to retrieve this by name :(
const enemy_layer_index = 4

func set_direction_right():
    direction.x = 1

func set_direction_left():
    direction.x = -1

func enable_player_collision():
    $Collider.set_collision_mask_value(player_layer_index, true)

func enable_enemy_collision():
    $Collider.set_collision_mask_value(enemy_layer_index, true)

func _physics_process(_delta: float) -> void:
    transform = transform.translated_local(direction * move_speed)
    sprite.transform = sprite.transform.rotated_local(0.07)

func _on_collider_body_entered(body: Node2D) -> void:
    queue_free() # Destroy the projectile

    # This should be a CharacterBody2D of the player. If this cast
    # fails, it means we have a different body that can collide with
    # projectile and we should handle it explicitly.
    var player := body as CharacterBody2D
    player.take_damage(1) # TODO variable damage?


func _on_collider_area_entered(_area: Area2D) -> void:
    queue_free() # Destroy the projectile

    # This should be an Area of enemy.
