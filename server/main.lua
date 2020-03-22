local enet = require "enet"
local ser = require "libs/binser"
local bump = require "libs/bump"
local host = enet.host_create("fowl.antloop.world:5700")
world  = bump.newWorld(64)
local level = require "level"
local entities = {}
require "utils"

level:load("res/the_island.png")

while true do
    local event = host:service(100)
    while event do
        if event.type == "receive" then
            local data = ser.d(event.data)[1]
            local uid = event.peer:index()

            if data.event == 'move' then
                local dx = 1*data.x
                local dy = 1*data.y
                local position = entities[uid].position

                position.x, position.y, collisions = world:move(uid, position.x + dx, position.y + dy)

                for p=1, host:peer_count() do
                    host:get_peer(p):send(ser.s({event='move', x=position.x, y=position.y, uid=uid}))
                end
            end

            -- event.peer:send("pong")
        elseif event.type == "connect" then
            local uid = event.peer:index()
            print("connected: ", event.peer, uid)

            entities[uid] = {
                position = {x = 120, y = 260},
                size     = {w = 16, h = 16},
                player   = {}
            }

            local position = entities[uid].position
            local size = entities[uid].size

            world:add(uid, position.x, position.y, size.w, size.h)

            event.peer:send(ser.s { event = 'connect', uid = uid })

            for p=1, uid do
                event.peer:send(ser.s {
                    event = 'spawn',
                    data = entities[p],
                    uid = p
                })
            end

            for p=1, host:peer_count() do
                host:get_peer(p):send(ser.s {
                    event = 'spawn',
                    data = entities[uid],
                    uid = uid
                })
            end
        elseif event.type == "disconnect" then
            local uid = event.peer:index()
            world:remove(uid)
            for p=1, host:peer_count() do
                host:get_peer(p):send(ser.s {
                    event = 'despawn',
                    uid = uid
                })
            end

            print("disconnected: ", event.peer, uid)
        end
        event = host:service()
    end
end
