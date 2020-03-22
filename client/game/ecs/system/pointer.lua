s.pointer = { "position", "size", "pointer" }
s.pointer.draw = function(i, position, size, pointer)
    local scale = 0.35
    local w = 16 * scale / 2
    local px, py = position.x + size.w / 2, position.y + size.h / 2

    px = px + math.cos(pointer.angle) * pointer.radius
    py = py + math.sin(pointer.angle) * pointer.radius

    love.graphics.setColor(1, 1, 1)
    local quad = spritesheet:get("pointer")

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(
        spritesheet.image,
        quad,
        px,
        py,
        pointer.angle,
        scale,
        scale,
        w,
        w
    )

    
end