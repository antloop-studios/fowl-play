local game = {}

function game:enter()
    self.camera = libs.camera(0, 0)
end

function game:update(dt)
    self.camera:rotate(dt)
end

function game:draw()
    self.camera:attach()

    love.graphics.setColor(1, 1, 0)
    love.graphics.rectangle("fill", -50, -50, 100, 100)

    self.camera:detach()
end

return game