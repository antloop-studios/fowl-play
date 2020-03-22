s.egg = {"position", "size", "player" }
s.egg.draw = function(i, position, size, player)
    if player.hasEgg then
        if player.team == "red" then
            love.graphics.setColor(0.2, 0.2, 0.8)
        else
            love.graphics.setColor(0.8, 0.2, 0.2)
        end

        local quad = spritesheet:get("egg")

        love.graphics.draw(
            spritesheet.image,
            quad,
            position.x + size.w,
            position.y,
            0,
            1,
            1,
            size.w / 2
        )
    end
end