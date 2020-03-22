s.dirt = { "position", "size", "color" }
s.dirt.draw = function(i, position, size, color)
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", position.x, position.y, size.w, size.h)
end