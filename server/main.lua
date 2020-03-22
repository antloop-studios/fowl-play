local enet = require "enet"
local ser = require "libs/binser"
local bump = require "libs/bump"
world = bump.newWorld(64)
local level = require "level"
require "utils"
require "libs/dump"

config = {server = "fowl2.antloop.world:5700"}

local entities = {}

function love.load(args)
    if args[1] == 'local' then config.server = "localhost:5700" end
    level:load("res/the_island.png")

    host = enet.host_create(config.server)
end

function love.update()
    local event = host:service(100)
    local f_update = false

    local queue = {}

    while event do
        if event.type == "receive" then
            local data = ser.d(event.data)[1]
            local uid = event.peer:index()

            if data.event == 'move' then
                local dx = 1 * data.x
                local dy = 1 * data.y
                local position = entities[uid].position

                position.x, position.y, collisions =
                    world:move(uid, position.x + dx, position.y + dy)

                entities[uid].ping = event.peer:round_trip_time()

                queue[#queue + 1] = {type = 'move', entities = entities}

            elseif data.event == 'punch' then
                queue[#queue + 1] = {
                    type = 'punch',
                    uid = uid,
                    dx = data.dx,
                    dy = data.dy,
                    angle = data.angle
                }

                local uid = event.peer:index()
                local px, py = entities[uid].position.x,
                               entities[uid].position.y

                for i, entity in pairs(entities) do
                    if i ~= uid then
                        local ex, ey = entity.position.x, entity.position.y

                        local da = math.atan2(py - ey, px - ex)
                        local dex = math.cos(da) * 16
                        local dey = math.sin(da) * 16

                        local hx = data.dx + dex
                        local hy = data.dy + dey

                        local hit = math.abs(hx) < 10 and math.abs(hy) < 10

                        if math.distance(px, py, ex, ey) < 32 and hit then
                            entities[i].hearts.hp = entities[i].hearts.hp - 1

                            if entities[i].hearts.hp == 0 then
                                entities[i] =
                                    {
                                        position = {x = 120, y = 260},
                                        size = {w = 16, h = 16},
                                        player = {},
                                        hearts = {hp = 3}
                                    }
                            end
                            queue[#queue + 1] =
                                {
                                    type = 'hit',
                                    uid = i,
                                    hp = entities[i].hearts.hp
                                }
                        end
                    end
                end

            end
        elseif event.type == "connect" then
            local uid = event.peer:index()
            print("connected: ", event.peer, uid)

            entities[uid] = {
                position = {x = 120, y = 260},
                size = {w = 16, h = 16},
                player = {},
                hearts = {hp = 3}
            }

            local position = entities[uid].position
            local size = entities[uid].size

            world:add(uid, position.x, position.y, size.w, size.h)

            event.peer:send(ser.s{
                type = 'connect',
                uid = uid,
                entities = entities
            })

            queue[#queue + 1] = {
                type = 'spawn',
                data = entities[uid],
                uid = uid
            }

        elseif event.type == "disconnect" then
            local uid = event.peer:index()
            world:remove(uid)

            queue[#queue + 1] = {type = 'despawn', uid = uid}

            print("disconnected: ", event.peer, uid)
        end
        event = host:service()
    end

    host:broadcast(ser.s{type = 'queue', queue = queue})
end
