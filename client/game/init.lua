game = {
    dt = 0,
    uid = 0
}


local level = require "game/level"
e, c, s     = unpack(libs.ecs)

love.graphics.setDefaultFilter("nearest", "nearest")

spritesheet = libs.shits:load("res/sheets/monochrome_transparent.png", 16)
spritesheet:name(25, 0, "player")

require "game/ecs"


local enet = require "enet"
ser = require "libs/binser"
local address, port = "fowl.antloop.world", 5700

require "libs/dump"

function game:enter()
    self.camera = libs.camera(0, 0, 1, 0)
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

    level:load("res/the_island.png")
end

function game:update(dt)
    self.dt = dt
    self.input:update()

    if self.input:get("quit") == 1 then
        love.event.quit()
    end

    local event = self.host:service()
    while event do
        if event.type == "receive" then
            local data = ser.d(event.data)[1]

            if data.event == 'spawn' then
                local id
                if data.uid == self.uid then
                    data.data.color = {0,0,1}
                    id = e.player(data.data)
                else
                    id = e.block(data.data)
                end
                self.entities[data.uid] = {e = e.get(id), id = id}
            elseif data.event == 'connect' then
                self.uid = data.uid
            elseif data.event == 'despawn' then
                e.delete(self.entities[data.uid].id)
            elseif data.event == 'move' then
                self.entities[data.uid].e.position.x = data.x
                self.entities[data.uid].e.position.y = data.y
            end
        end
        event = self.host:service()
    end

    s(s.player)
end

function game:draw()
    self.camera:attach()

    s(s.block, s.sprite)

    self.camera:detach()

    love.graphics.print(dump(self.entities))
end

function game:leave()
    self.host:destroy()
end

return game
