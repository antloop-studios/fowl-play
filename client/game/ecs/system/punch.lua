s.punch = {"position", "size", "punch"}
s.punch.draw = function(i, position, size, punch)
    position.x = position.x + math.cos(punch.angle) * game.dt * 16
    position.y = position.y + math.sin(punch.angle) * game.dt * 16

    punch.scale = punch.scale + game.dt * 5

    if punch.scale >= 2 then
        e.delete(i)
    end

    local quad = spritesheet:get("punch")

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(
        spritesheet.image,
        quad,
        position.x + math.cos(punch.angle) * 17,
        position.y + math.sin(punch.angle) * 17,
        punch.angle + math.pi / 4,
        punch.scale,
        punch.scale,
        10,
        4
    )
end
