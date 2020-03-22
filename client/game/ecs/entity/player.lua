e.player = { "position", "size", "player", "sprite", "hearts" }

s.player = { "position", "size", "player", "hearts" }
s.player.update = function(i, position, size, player, hearts)
    hearts.hp = player.life
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
