game = {
    dt = 0,
    uid = 0
}


local level = require "game/level"
e, c, s     = unpack(libs.ecs)

love.graphics.setDefaultFilter("nearest", "nearest")

spritesheet = libs.shits:load("res/sheets/monochrome_transparent.png", 16)
spritesheet:name(25, 0, "player")
spritesheet:name(3, 1, "tree")
spritesheet:name(24, 20, "pointer")



require "game/ecs"

local enet = require "enet"
ser = require "libs/binser"

require "libs/dump"

function game:enter()
    self.camera = libs.camera(0, 0, 4, 0)
    self.world  = libs.bump.newWorld(64)
    self.input  = libs.baton.new {
        controls = {
            left  = {'key:a', 'axis:leftx-', 'button:dpleft' },
            right = {'key:d', 'axis:leftx+', 'button:dpright'},
            up    = {'key:w', 'axis:lefty-', 'button:dpup'   },
            down  = {'key:s', 'axis:lefty+', 'button:dpdown' },
            punch = {'mouse:1'},
            quit  = {'key:escape'}
        },
        pairs = {
            move = {'left', 'right', 'up', 'down'}
        },
        joystick = love.joystick.getJoysticks()[1],
    }

    self.entities = {}

    self.host = enet.host_create()
    self.server = self.host:connect(config.server)

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
                print('spawn', data.uid)
                local id
                if data.uid == self.uid then
                    data.data.sprite = { name = "player", color = { 84 / 200, 81 / 200, 75 / 200 }, scale = 1 }
                    data.data.controller = {}
                    data.data.pointer = { angle = 0, radius = 16 }
                    id = e.cplayer(data.data)
                else
                    data.data.sprite = { name = "player", color = { 0, 1, 0 }, scale = 1 }
                    data.data.ping = nil
                    id = e.player(data.data)
                end
                self.entities[data.uid] = {e = e.get(id), id = id}

            elseif data.event == 'connect' then
                print('connect', data.uid)
                self.uid = data.uid

            elseif data.event == 'despawn' then
                e.delete(self.entities[data.uid].id)
                self.entities[data.uid] = nil

            elseif data.event == 'move' then
                for i, entity in pairs(data.entities) do
                    if self.entities[i] then
                        self.entities[i].ping = entity.ping
                        self.entities[i].e.position.x = entity.position.x
                        self.entities[i].e.position.y = entity.position.y
                    end
                end
            end
        end
        event = self.host:service()
    end

    s(s.cplayer)
end

function game:draw()
    self.camera:attach()

    s(s.dirt, s.sprite, s.pointer)

    self.camera:detach()

    love.graphics.setColor(0, 0, 0)
    love.graphics.print(dump(self.entities))
end

function game:leave()
    self.host:destroy()
end

return game
