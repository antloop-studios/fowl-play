e.player = { "position", "size", "color", "player" }

s.player = { "position", "size", "player" }
s.player.update = function(i, position, size, player)
    local x, y = game.input:get("move")

    local dx = x * 100 * game.dt
    local dy = y * 100 * game.dt

    position.x, position.y, collisions = game.world:move(i, position.x + dx, position.y + dy)

    game.camera:lockX(math.floor(position.x), libs.camera.smooth.linear(300))
    game.camera:lockY(math.floor(position.y), libs.camera.smooth.linear(300))

end