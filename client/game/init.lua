local game = {
    entities = {}
}

function game:enter()
    self.camera = libs.camera(0, 0)
    self.world  = libs.bump.newWorld(64)
    self.input  = libs.baton.new {
        controls = {
            left  = {'key:a', 'axis:leftx-', 'button:dpleft' },
            right = {'key:d', 'axis:leftx+', 'button:dpright'},
            up    = {'key:w', 'axis:lefty-', 'button:dpup'   },
            down  = {'key:s', 'axis:lefty+', 'button:dpdown' },
        },
        pairs = {
            move = {'left', 'right', 'up', 'down'}
        },
        joystick = love.joystick.getJoysticks()[1],
    }
end

function game:update(dt)
    self.input:update()
end

function game:draw()
    self.camera:attach()


    self.camera:detach()
end

return game