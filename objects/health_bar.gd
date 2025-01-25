extends HBoxContainer

@export var max_health: int = 5
@export var current_health: int = 5
@onready var bubble_image = preload("res://objects/buble_16.png")

func _ready() -> void:
    update_health_bar()

func update_health_bar() -> void:
    # Add or remove health bubbles
    while get_child_count() < max_health:
        var bubble = TextureRect.new()
        bubble.texture = bubble_image
        bubble.visible = true
        add_child(bubble)

    while get_child_count() > max_health:
        get_child(get_child_count() - 1).queue_free()

    # Update visibility of bubbles
    for i in range(max_health):
        get_child(i).visible = i < current_health

func set_health(current: int, max: int) -> void:
    max_health = max
    current_health = current
    update_health_bar()

func take_damage(amount: int) -> void:
    current_health = clamp(current_health - amount, 0, max_health)
    update_health_bar()

func heal(amount: int) -> void:
    current_health = clamp(current_health + amount, 0, max_health)
    update_health_bar()
