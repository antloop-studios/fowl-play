e.player = { "position", "size", "color", "player" }

s.player = { "position", "size", "player" }
s.player.update = function(i, position, size, player)
    local x, y = game.input:get("move")

    local dx = x * 100 * game.dt
    local dy = y * 100 * game.dt

    position.x, position.y, collisions = game.world:move(i, position.x + dx, position.y + dy)

    move_camera(position.x, position.y)
end

function move_camera(x, y)
    local speed = 10
    local radius_to_player = 10

    local cx, cy = game.camera.x, game.camera.y

    if math.distance(x, y, cx, y) > radius_to_player then
        cx = math.cerp(cx, x, game.dt * speed)
        cy = math.cerp(cy, y, game.dt * speed)
    end

    game.camera.x, game.camera.y = cx, cy
end