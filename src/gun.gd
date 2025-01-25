extends Node2D

enum KIND {AGRESSIVE_BUBBLE_DESTROYER, MOLD_REMOVER, MULTI_BUBBLI, BUBBLETHROWER, BULBULATOR}

@onready var muzzle: Marker2D = $Marker2D
@onready var scene_projectile = preload("res://src/projectile.tscn")

@export var projectile_container: Node2D

@export var kind : KIND = KIND.AGRESSIVE_BUBBLE_DESTROYER

var time : float = .0
const AMPLIFICATION : float = 4.0
const OMEGA : float = 3.0

const WEIGHT : float = .3

var previous_global_position : Vector2 = Vector2.ZERO
var projectile_type := Projectile.ProjectileType.PlayerSoap

func set_player_index(idx):
    $Sprite2D.frame = idx
    if idx == 1:
        projectile_type = Projectile.ProjectileType.PlayerWater

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    # update floating state
    time += delta

    # follow mouse
    look_at(get_global_mouse_position())

    # flip the weapon accordingly to the position of the curosr
    scale.y = -1 if rotation > (PI / 2) and rotation < (3 * PI / 2) else 1

    # wiggle + spring-like float
    global_position = lerp(previous_global_position, get_parent().global_position, WEIGHT)
    global_position.y += AMPLIFICATION * sin(OMEGA * time)

    # save previous state
    previous_global_position = global_position

func shoot():
    match kind:
        KIND.AGRESSIVE_BUBBLE_DESTROYER:
            var p = scene_projectile.instantiate()

            get_tree().root.add_child(p)

            p.global_position = muzzle.global_position
            p.rotation = rotation
            p.set_projectile_type(projectile_type)

        KIND.MOLD_REMOVER:
            var rs: Array[float] = [ -PI / 4, 0, PI / 4 ]
            for idx in 3:
                var p = scene_projectile.instantiate()

                get_tree().root.add_child(p)

                p.global_position = muzzle.global_position
                p.rotation = rotation

                p.rotate(rs[idx])
                p.set_projectile_type(projectile_type)

        _:
            print("WARNING: no-op!")
