s.sprite = {"position", "size", "sprite"}
s.sprite.draw = function(i, position, size, sprite)
    local quad = spritesheet:get(sprite.name)

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(
        spritesheet.image,
        quad,
        position.x + size.w / 2,
        position.y,
        0,
        1,
        1,
        size.w / 2
    )
end
