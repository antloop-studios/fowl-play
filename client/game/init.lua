game = {
    dt = 0
}


local level = require "game/level"
e, c, s     = unpack(libs.ecs)

love.graphics.setDefaultFilter("nearest", "nearest")

spritesheet = libs.shits:load("res/sheets/monochrome_transparent.png", 16)
spritesheet:name(25, 0, "player")

require "game/ecs"

function game:enter()
    self.camera = libs.camera(0, 0, 3, 0)
    self.world  = libs.bump.newWorld(64)
    self.input  = libs.baton.new {
        controls = {
            left  = {'key:a', 'axis:leftx-', 'button:dpleft' },
            right = {'key:d', 'axis:leftx+', 'button:dpright'},
            up    = {'key:w', 'axis:lefty-', 'button:dpup'   },
            down  = {'key:s', 'axis:lefty+', 'button:dpdown' },
            quit  = {'key:escape'}
        },
        pairs = {
            move = {'left', 'right', 'up', 'down'}
        },
        joystick = love.joystick.getJoysticks()[1],
    }

    level:load("res/the_island.png")
end

function game:update(dt)
    self.dt = dt
    self.input:update()

    if self.input:get("quit") == 1 then
        love.event.quit()
    end

    s(s.player)
end

function game:draw()
    self.camera:attach()

    s(s.block, s.sprite)

    self.camera:detach()
end

return game