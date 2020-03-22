s.hearts = {"position", "size", "hearts"}
s.hearts.draw = function(i, position, size, hearts)
    local quad = spritesheet:get("heart")

    for x = 1, hearts.hp do
        love.graphics.setColor(0.5, 0, 0)
        love.graphics.draw(
            spritesheet.image,
            quad,
            position.x - size.w / 2 + x * 8 - 2,
            position.y - 8,
            0,
            0.5,
            0.5,
            8 * 0.5
        )
    end
end
