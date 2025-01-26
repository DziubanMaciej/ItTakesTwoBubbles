extends HBoxContainer

@export var max_health: int = 5
@export var current_health: int = 5

@onready var health_bar: ProgressBar = null

func _ready() -> void:
    setup_health_bar()
    update_health_bar()

func setup_health_bar() -> void:
    health_bar = $ProgressBar if has_node("ProgressBar") else ProgressBar.new()

    if health_bar.get_parent() != self:
        health_bar.min_value = 0
        health_bar.max_value = max_health
        health_bar.value = current_health
        health_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        health_bar.custom_minimum_size = Vector2(200, 20)
        health_bar.percent_visible = false
        add_child(health_bar)

func update_health_bar() -> void:
    if health_bar:
        health_bar.max_value = max_health
        health_bar.value = current_health

        var base_width = 5
        var width_per_hp = 10
        health_bar.custom_minimum_size.x = base_width + (width_per_hp * max_health)

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
