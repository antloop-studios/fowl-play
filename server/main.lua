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

                f_update = true

            elseif data.event == 'punch' then
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
                            entities[i].player.life =
                                entities[i].player.life - 1

                            if entities[i].player.life == 0 then
                                entities[i] =
                                    {
                                        position = {x = 120, y = 260},
                                        size = {w = 16, h = 16},
                                        player = {life = 3}
                                    }
                            end
                            host:broadcast(ser.s{event = 'hit', uid = i})
                            f_update = true
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
                player = {life = 3}
            }

            local position = entities[uid].position
            local size = entities[uid].size

            world:add(uid, position.x, position.y, size.w, size.h)

            event.peer:send(ser.s{event = 'connect', uid = uid})

            for p = 1, host:peer_count() do
                if host:get_peer(p):state() == 'connected' then
                    if p ~= uid then
                        event.peer:send(ser.s{
                            event = 'spawn',
                            data = entities[p],
                            uid = p
                        })
                    end
                end
            end

            host:broadcast(ser.s{
                event = 'spawn',
                data = entities[uid],
                uid = uid
            })

            f_update = true

        elseif event.type == "disconnect" then
            local uid = event.peer:index()
            world:remove(uid)

            host:broadcast(ser.s{event = 'despawn', uid = uid})

            print("disconnected: ", event.peer, uid)

            f_update = true
        end
        event = host:service()
    end

    if f_update then
        f_update = false

        host:broadcast(ser.s({event = 'move', entities = entities}), 0,
                       "unreliable")
    end

end
