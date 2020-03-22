-- (c)ontrolled player
e.cplayer = {"position", "size", "player", "sprite", "controller", "pointer"}

s.cplayer = {"position", "size", "pointer", "player", "controller"}
s.cplayer.update = function(i, position, size, pointer)
    move_camera(position.x, position.y)

    local x, y = game.input:get("move")

    if x ~= 0 or y ~= 0 then
        game.server:send(ser.s({event = 'move', x = x, y = y}))
    end

    local mx, my = game.camera:mousePosition()
    local cx, cy = position.x + size.w / 2, position.y + size.h / 2

    pointer.angle = math.atan2(my - cy, mx - cx)

    if game.input:pressed("punch") then
        local dx = math.cos(pointer.angle) * 16
        local dy = math.sin(pointer.angle) * 16
        game.server:send(ser.s({event = 'punch', dx = dx, dy = dy}))

        e.punch({
            position = {
                x = position.x + size.w / 2,
                y = position.y + size.h / 2
            },
            size = {w = 16, h = 16},
            punch = {angle = pointer.angle, scale = 1}
        })
    end

    if game.hit then
        game.server:send(ser.s({event='move', x=math.random(-5, 5), y=math.random(-5, 5)}))

        game.hit = false
    end
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
