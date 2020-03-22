e.player = { "position", "size", "sprite", "player" }

s.player = { "position", "size", "player" }
s.player.update = function(i, position, size, player)
    move_camera(position.x, position.y)

    local x, y = game.input:get("move")

    local event = host:service()
    while event do
        if event.type == "receive" then
            local d = ser.d(event.data)[1]
            if d.uid then
                player.uid = d.uid
            else
                game.entities = d
            end
        end
        event = host:service()
    end

    server:send(ser.s({ player=player, move = {x,y} }))

    -- local len = (x^2 + y^2)^0.5
    -- if len == 0 then
    --     len = 1
    -- end

    -- local dx = (x / len) * 100 * game.dt
    -- local dy = (y / len) * 100 * game.dt

    -- position.x, position.y, collisions = game.world:move(i, position.x + dx, position.y + dy)
end

function move_camera(x, y)
    local speed = 10
    local radius_to_player = 2

    local cx, cy = game.camera.x, game.camera.y

    if math.distance(x, y, cx, y) > radius_to_player then
        cx = math.cerp(cx, x, game.dt * speed)
        cy = math.cerp(cy, y, game.dt * speed)
    end

    game.camera.x, game.camera.y = cx, cy
end
