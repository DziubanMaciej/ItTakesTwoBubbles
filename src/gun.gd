extends Node2D

enum KIND {AGRESSIVE_BUBBLE_DESTROYER, MOLD_REMOVER, MULTI_BUBBLI, BUBBLETHROWER, BULBULATOR}

@onready var muzzle: Marker2D = $Marker2D
@onready var scene_projectile = preload("res://src/projectile.tscn")

@export var projectile_container: Node2D
@export var player = "player0"

@export var kind : KIND = KIND.AGRESSIVE_BUBBLE_DESTROYER

var action_fire = str(player, "_fire")

var time : float = .0
const AMPLIFICATION : float = 4.0
const OMEGA : float = 3.0

const WEIGHT : float = .5

var previous_global_position : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    # update floating state
    time += delta

    # self transformation
    global_position = lerp(previous_global_position, get_parent().global_position, WEIGHT)
    global_position.y += AMPLIFICATION * sin(OMEGA * time)

    # actions
    if Input.is_action_just_pressed(action_fire):
        match kind:
            KIND.AGRESSIVE_BUBBLE_DESTROYER:
                var p = scene_projectile.instantiate()

                get_tree().root.add_child(p)

                p.global_position = muzzle.global_position
                p.rotation = rotation

                p.enable_enemy_collision()

            KIND.MOLD_REMOVER:
                var rs: Array[float] = [ -PI / 4, 0, PI / 4 ]
                for idx in 3:
                    var p = scene_projectile.instantiate()

                    get_tree().root.add_child(p)

                    p.global_position = muzzle.global_position
                    p.rotation = rotation

                    p.rotate(rs[idx])
                    p.enable_enemy_collision()

            _:
                print("WARNING: no-op!")


    # save previous state
    previous_global_position = global_position
