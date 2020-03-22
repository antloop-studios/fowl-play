game = {
    dt = 0,
    uid = 0,
    hit = false,
}


local level = require "game/level"
e, c, s     = unpack(libs.ecs)

love.graphics.setDefaultFilter("nearest", "nearest")

spritesheet = libs.shits:load("res/sheets/monochrome_transparent.png", 16)
spritesheet:name(25, 0,  "player")
spritesheet:name(23, 22, "heart")
spritesheet:name(25, 7,  "chick")

spritesheet:name(3, 1,   "tree1")
spritesheet:name(5, 1,   "tree2")
spritesheet:name(3, 2,   "tree3")

spritesheet:name(24, 20, "pointer")
spritesheet:name(25, 11, "punch")

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
    self.hit = false

    self.host = enet.host_create()
    self.server = self.host:connect(config.server)

    level:load("res/the_island.png")
end

function game:update(dt)
    libs.shack:update(dt)
    self.dt = dt
    self.input:update()

    if self.input:get("quit") == 1 then
        self.server:disconnect()
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
                    data.data.hearts  = { hp = 3 }
                    id = e.cplayer(data.data)
                else
                    data.data.sprite = { name = "player", color = { 0, 1, 0 }, scale = 1 }
                    data.data.hearts  = { hp = 3 }
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

            elseif data.event == 'hit' then
                if data.uid == self.uid then
                    libs.shack:setShake(20)
                    self.hit = true
                end

            elseif data.event == "punch" then
                if data.uid ~= self.uid then
                    local position = self.entities[data.uid].e.position
                    local size = self.entities[data.uid].e.size

                    e.punch({
                        position = {
                            x = position.x + size.w / 2,
                            y = position.y + size.h / 2
                        },
                        size = {w = 16, h = 16},
                        punch = {angle = data.angle, scale = 1}
                    })
                end

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
    libs.shack:apply()

    s(s.dirt, s.sprite, s.pointer, s.punch, s.hearts)

    self.camera:detach()

    love.graphics.setColor(1, 1, 1)
    love.graphics.print(dump(self.entities))
end

function game:leave()
    self.server:disconnect()
end

return game
