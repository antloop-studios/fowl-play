game = {
    dt = 0
}


local level = require "game/level"
e, c, s     = unpack(libs.ecs)

require "game/ecs"

local enet = require "enet"
local ser = require "libs/binser"
local address, port = "fowl.antloop.world", 5700

require "libs/dump"

function game:enter()
    self.camera = libs.camera(0, 0, 2, 0)
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


    self.entities = {}

    self.host = enet.host_create()
    self.server = self.host:connect(address .. ":" .. port)
    self.status = {add = function(self, ...) self[(#self + 1) % 5] = {...} end}
    self.data = {uid = 0, left = false, right = false, up = false, down = false}

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

    s(s.block)

    -- for i, entity in pairs(self.entities) do
    --     if entity.uid == data.uid then
    --         love.graphics.setColor(0.2, 0.5, 0.7, 1)
    --     else
    --         love.graphics.setColor(0.5, 0.5, 0.5, 1)
    --     end
    --     love.graphics.circle("fill", entity.x or 0, entity.y or 0, 10)
    -- end

    self.camera:detach()

    love.graphics.print(dump(self.entities))
end

function game:leave()
    self.host:destroy()
end

return game
