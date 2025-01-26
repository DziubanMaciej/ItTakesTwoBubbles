extends Camera2D

# Adjustable variables exposed in the editor for flexibility
@export var min_zoom: float = 1.0  # Minimum zoom level
@export var max_zoom: float = 1.5  # Maximum zoom level
@export var zoom_speed: float = 1.0  # Speed at which zoom changes
@export var margin: Vector2 = Vector2(120, 120)  # Margins around players to keep them within view
@export var base_resolution: Vector2 = Vector2(1920, 1080)  # Base resolution for scaling calculations

func _process(delta):
    # Retrieve the list of players
    var players = LevelGlobals.players
    if players.is_empty():
        return  # Skip processing if no players are present

    # Calculate the center position based on the players' positions
    var center_position = Vector2.ZERO
    for player in players:
        center_position += player.global_position
    center_position /= float(players.size())
    global_position = center_position

    # Determine the maximum distance between players
    var max_distance = 0.0
    for i in range(players.size()):
        for j in range(i + 1, players.size()):
            var distance = players[i].global_position.distance_to(players[j].global_position)
            if distance > max_distance:
                max_distance = distance

    # Adjust the zoom level based on the players' spread and viewport size
    var viewport_size = Vector2(get_viewport().size)
    var scale_factor = viewport_size / base_resolution
    var adjusted_margin = margin * scale_factor

    var zoom_factor_x = viewport_size.x / (max_distance + adjusted_margin.x)
    var zoom_factor_y = viewport_size.y / (max_distance + adjusted_margin.y)
    var target_zoom = min(zoom_factor_x, zoom_factor_y)

    # Clamp the zoom level between the minimum and maximum values
    target_zoom = clamp(target_zoom, min_zoom, max_zoom)

    # Smoothly interpolate to the target zoom level
    zoom = zoom.lerp(Vector2(target_zoom, target_zoom), zoom_speed * delta)

    # Ensure players stay within the camera's view
    limit_player_movement(players)

func limit_player_movement(players: Array) -> void:
    # Calculate the camera's visible area in world coordinates
    var camera_size = Vector2(get_viewport().size) / zoom
    var half_camera_size = camera_size * 0.5

    # Define the camera boundaries
    var camera_left = global_position.x - half_camera_size.x
    var camera_right = global_position.x + half_camera_size.x
    var camera_top = global_position.y - half_camera_size.y
    var camera_bottom = global_position.y + half_camera_size.y

    # Constrain each player's position within the camera boundaries
    for player in players:
        var player_pos = player.global_position
        player_pos.x = clamp(player_pos.x, camera_left + margin.x, camera_right - margin.x)
        player_pos.y = clamp(player_pos.y, camera_top + margin.y, camera_bottom - margin.y)
        player.global_position = player_pos
