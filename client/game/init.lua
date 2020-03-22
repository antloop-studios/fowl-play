game = {dt = 0, uid = 0, hit = false}

local level = require "game/level"
e, c, s = unpack(libs.ecs)

love.graphics.setDefaultFilter("nearest", "nearest")

spritesheet = libs.shits:load("res/sheets/monochrome_transparent.png", 16)
spritesheet:name(25, 0, "player")
spritesheet:name(23, 22, "heart")
spritesheet:name(25, 7, "chick")
spritesheet:name(18, 29, "egg")

spritesheet:name(3, 1, "tree1")
spritesheet:name(5, 1, "tree2")
spritesheet:name(3, 2, "tree3")

spritesheet:name(24, 20, "pointer")
spritesheet:name(25, 11, "punch")

require "game/ecs"

local enet = require "enet"
ser = require "libs.binser"

local messageHandler = require "game.messages"

require "libs/dump"

function game:enter()
    self.camera = libs.camera(0, 0, 4, 0)
    self.world = libs.bump.newWorld(64)
    self.input = libs.baton.new{
        controls = {
            left = {'key:a', 'axis:leftx-', 'button:dpleft'},
            right = {'key:d', 'axis:leftx+', 'button:dpright'},
            up = {'key:w', 'axis:lefty-', 'button:dpup'},
            down = {'key:s', 'axis:lefty+', 'button:dpdown'},
            punch = {'mouse:1'},
            quit = {'key:escape'}
        },
        pairs = {move = {'left', 'right', 'up', 'down'}},
        joystick = love.joystick.getJoysticks()[1]
    }

    self.entities = {}
    self.teams = {}
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
            local message = ser.d(event.data)[1]

            if message.type == 'connect' then
                messageHandler[message.type](self, message)
            elseif message.type == 'queue' then
                for i, event in ipairs(message.queue) do
                    if messageHandler[event.type] then
                        messageHandler[event.type](self, event)
                    else
                        print('unhandled event', event.type)
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

function game:leave() self.server:disconnect() end

return game
