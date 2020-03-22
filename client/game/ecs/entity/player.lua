e.player = { "position", "size", "player", "sprite", "hearts" }

s.player = { "position", "size", "player", "hearts" }
s.player.update = function(i, position, size, player)
    -- move_camera(position.x, position.y)

    -- local x, y = game.input:get("move")

    -- if x ~= 0 or y ~= 0 then
    --     game.server:send(ser.s({event='move', x=x, y=y}))
    -- end
end

function move_camera(x, y)
    local speed = 10
    local radius_to_player = 0

    local cx, cy = game.camera.x, game.camera.y

    if math.distance(x, y, cx, y) > radius_to_player then
        cx = math.cerp(cx, x, game.dt * speed)
        cy = math.cerp(cy, y, game.dt * speed)
    end

    game.camera.x, game.camera.y = cx, cy
end
