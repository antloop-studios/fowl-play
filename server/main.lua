local enet = require "enet"
local ser = require "libs/binser"
local bump = require "libs/bump"
world  = bump.newWorld(64)
local level = require "level"
local entities = {}
require "utils"

config = {
    server = "fowl.antloop.world:5700"
}


function love.load(args)
    if args[1] == 'local' then
        config.server = "localhost:5700"
    end
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
                local dx = 1*data.x
                local dy = 1*data.y
                local position = entities[uid].position

                position.x, position.y, collisions = world:move(uid, position.x + dx, position.y + dy)

                entities[uid].ping = event.peer:round_trip_time()
                f_update = true
            end
        elseif event.type == "connect" then
            local uid = event.peer:index()
            print("connected: ", event.peer, uid)

            entities[uid] = {
                position = {x = 120, y = 260},
                size     = {w = 16, h = 16},
                player   = {},
            }

            local position = entities[uid].position
            local size = entities[uid].size

            world:add(uid, position.x, position.y, size.w, size.h)

            event.peer:send(ser.s { event = 'connect', uid = uid })

            for p=1, host:peer_count() do
                if host:get_peer(p):state() == 'connected' then
                    if p ~= uid then
                        event.peer:send(ser.s {
                            event = 'spawn',
                            data = entities[p],
                            uid = p
                        })
                    end
                end
            end

            host:broadcast(ser.s {
                event = 'spawn',
                data = entities[uid],
                uid = uid
            })

            f_update = true

        elseif event.type == "disconnect" then
            local uid = event.peer:index()
            world:remove(uid)

            host:broadcast(ser.s {
                event = 'despawn',
                uid = uid
            })

            print("disconnected: ", event.peer, uid)

            f_update = true

        end
        event = host:service()
    end

    if f_update then
        f_update = false

        host:broadcast(ser.s({event='move',entities=entities}))
    end

end
