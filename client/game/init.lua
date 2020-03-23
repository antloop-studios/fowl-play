game = {dt = 0, uid = 0, hit = false, log = {}}

local level = require "game/level"
e, c, s = unpack(libs.ecs)

love.graphics.setDefaultFilter("nearest", "nearest")

spritesheet = libs.shits:load("res/sheets/monochrome_transparent.png", 16)
spritesheet:name(25, 9, "player")
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

    self.w = love.graphics.getWidth()
    self.h = love.graphics.getHeight()

    self.entities = {}
    self.teams = {}
    self.queue = {}
    self.hit = false

    self.host = enet.host_create()
    self.server = self.host:connect(config.server)

    level:load("res/the_island.png")

    self.audio = {
        ambient = love.audio.newSource("res/audio/ambient/01.wav", 'stream'),
        death = {
            love.audio.newSource("res/audio/death/01.mp3", "static"),
            love.audio.newSource("res/audio/death/02.wav", "static")
        },
        loss = {love.audio.newSource("res/audio/loss/01.mp3", "static")},
        move = {
            love.audio.newSource("res/audio/move/01.wav", "static"),
            love.audio.newSource("res/audio/move/02.wav", "static"),
            love.audio.newSource("res/audio/move/03.wav", "static")
        },
        punch = {
            love.audio.newSource("res/audio/punch/01.wav", "static"),
            love.audio.newSource("res/audio/punch/02.wav", "static")
        },
        warning = {love.audio.newSource("res/audio/warning/01.wav", "static")},
        win = {love.audio.newSource("res/audio/win/01.wav", "static")},
        ding = {love.audio.newSource("res/audio/ding/01.wav", "static")},
        woosh = {love.audio.newSource("res/audio/woosh/01.mp3", "static")}
    }

    self.audio.ambient:setLooping(true)
    self.audio.ambient:play()
end

function game:send_log(msg, color)
    table.insert(self.log, {msg = msg, color = color})

    if #self.log > 5 then table.remove(self.log, 1) end
end

function game:update(dt)
    libs.shack:update(dt)
    self.dt = dt
    self.input:update()
    self.queue = {}

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

    self.server:send(ser.s(self.queue))
end

function game:draw()
    self.camera:attach()
    libs.shack:apply()

    s(s.dirt, s.sprite, s.egg, s.pointer, s.punch, s.hearts)

    self.camera:detach()

    love.graphics.setColor(0, 0, 0, 0.25)
    love.graphics.rectangle("fill", 12, 20, 228, 16 * 5)

    for i, v in ipairs(self.log) do
        local color = {1, 1, 1, i / #self.log}
        if v.color then
            color = {v.color[1], v.color[2], v.color[3], i / #self.log}
        end

        love.graphics.setColor(color)

        love.graphics.print(v.msg, 16, 10 + 14 * i)
    end

    love.graphics.setColor(255, 255, 255)

    if self.teams.red and self.teams.blue then
        love.graphics
            .print("RED: " .. self.teams.red.score, self.w / 2 - 20, 20)
        love.graphics.print("BLUE: " .. self.teams.blue.score, self.w / 2 - 20,
                            40)
        love.graphics.print("Red players: " .. self.teams.red.players,
                            self.w - 100, 62)
        love.graphics.print("Blue players: " .. self.teams.blue.players,
                            self.w - 100, 78)
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("FPS  " .. love.timer.getFPS(), self.w - 100, 30)
    if self.entities[self.uid] then
        love.graphics.print("PING " .. self.entities[self.uid].ping .. "ms",
                            self.w - 100, 46)
    end
end

function game:leave() self.server:disconnect() end

return game
