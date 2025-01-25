extends Node2D

@onready var sprite = $Sprite2D

var direction = Vector2(1, 0)
var move_speed = 20

const player_layer_index = 2 # No way to retrieve this by name :(
const enemy_layer_index = 4

# Added variables for bounce handling
var bounces = 0
const max_bounces = 3

func set_direction_right():
    direction.x = 1

func set_direction_left():
    direction.x = -1

func set_direction(vec : Vector2):
    direction = vec.normalized()

func enable_player_collision():
    $Collider.set_collision_mask_value(player_layer_index, true)

func enable_enemy_collision():
    $Collider.set_collision_mask_value(enemy_layer_index, true)

func _physics_process(_delta: float) -> void:
    transform = transform.translated_local(direction * move_speed)
    sprite.transform = sprite.transform.rotated_local(0.07)

func _on_collider_body_entered(body: Node2D) -> void:
    var tile = body as TileMap
    if tile:
        handle_bounce()
        return
    tile = body as TileMapLayer
    if tile:
        handle_bounce()
        return

    var player := body as CharacterBody2D
    if player:
        player.take_damage(1) # TODO variable damage?
        queue_free()
        return

    # This could be something else. Handle it
    print("WARNING: unhandled projectile collision!")
    queue_free()

func _on_collider_area_entered(area: Area2D) -> void:
    queue_free() # Destroy the projectile

    # This is a sketchy way to get to the enemy script, but whatever.
    var enemy = area.get_node("../..")
    enemy.take_damage(1)

# New function to handle bouncing logic
func handle_bounce():
    bounces += 1
    if bounces >= max_bounces:
        queue_free()
    else:
        # Simple reflection by reversing direction
        direction = -direction
