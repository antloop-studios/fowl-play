local enet = require "enet"
ser = require "libs/binser"
local bump = require "libs/bump"
local level = require "level"
require "utils"
require "libs/dump"
local messageHandler = require "messages"
config = {server = "fowl2.antloop.world:5700"}

game = {
    queueLossy = {},
    queueReliable = {},

    teamSpawn = {red = {x = 0, y = 0}, blue = {x = 255, y = 255}},
    teamColor = {red = {0.8, 0.1, 0.05}, blue = {0.05, 0.1, 0.8}},

    teams = {
        red = {players = 0, score = 0, capturing = false},
        blue = {players = 0, score = 0, capturing = false}
    },

    world = bump.newWorld(64),
    entities = {}
}

function love.load(args)
    if args[1] == 'local' then config.server = "localhost:5700" end
    level:load("res/the_island.png")

    host = enet.host_create(config.server)
end

function love.update()
    local event = host:service(100)

    game.queueLossy = {}
    game.queueReliable = {}

    while event do
        local uid = event.peer:index()

        if event.type == "receive" then
            local messages = ser.d(event.data)[1]
            for i, message in ipairs(messages) do
                if messageHandler[message.type] then
                    messageHandler[message.type](uid, event.peer, message)
                else
                    print('unhandled event type', message.type)
                end
            end
        elseif event.type == "connect" then
            messageHandler[event.type](uid, event.peer, event)
        elseif event.type == "disconnect" then
            messageHandler[event.type](uid, event.peer, event)
        end

        event = host:service()
    end

    host:broadcast(ser.s{type = 'queue', queue = game.queueReliable})
    host:broadcast(ser.s{type = 'queue', queue = game.queueLossy}, 0,
                   'unsequenced')
end
