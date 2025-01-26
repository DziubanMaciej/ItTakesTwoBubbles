extends CharacterBody2D

const SPEED : float = 300.0
const JUMP_VELOCITY : float = -550.0

var health : float = 100.0

var has_soap := false
var has_water := false

func _ready():
    pass

func take_damage(amount: int, projectile_type : Projectile.ProjectileType) -> void:
    health -= 10.0

    match projectile_type:
        Projectile.ProjectileType.PlayerSoap:
            $SoapEffect/Timer.stop()
            $SoapEffect/Timer.start()
            has_soap = true
            $SoapEffect.visible = true
        Projectile.ProjectileType.PlayerWater:
            $WaterEffect/Timer.stop()
            $WaterEffect/Timer.start()
            has_water = true
            $WaterEffect.visible = true

func _physics_process(delta):
    if not is_on_floor():
        velocity += get_gravity() * delta

    if is_on_floor() and is_on_wall():
        velocity.y = JUMP_VELOCITY

    var distance : float = INF
    var direction : Vector2 = Vector2.ZERO

    for p in LevelGlobals.players:
        var d : float = global_position.distance_to(p.global_position)

        if d < distance:
            distance = d

            if distance < LevelGlobals.TILE_SIZE * 10:
                direction = (p.global_position - global_position).normalized()
            else:
                direction = Vector2.ZERO

    velocity.x = direction.x * SPEED

    if health <= 0.0:
        LevelGlobals.enemies.erase(self)
        queue_free()

    # TODO(milliewaly): Looks cool!
    #$Sprite.scale.x = clamp(direction.x, -1, 1)

    move_and_slide()


func on_soap_end() -> void:
    has_soap = false
    $SoapEffect.visible = false


func on_water_end() -> void:
    has_water = false
    $WaterEffect.visible = false
