local enet = require "enet"
local ser = require "libs/binser"
local bump = require "libs/bump"
world = bump.newWorld(64)
local level = require "level"
require "utils"
require "libs/dump"

config = {server = "fowl2.antloop.world:5700"}

local entities = {}
local teams = {red = {players = 0, score = 0}, blue = {players = 0, score = 0}}
local teamColor = {red = {0.8, 0.1, 0.05}, blue = {0.05, 0.1, 0.8}}

function love.load(args)
    if args[1] == 'local' then config.server = "localhost:5700" end
    level:load("res/the_island.png")

    host = enet.host_create(config.server)
end

function love.update()
    local event = host:service(100)
    local f_update = false

    local queue = {}
    local collisions, count

    while event do
        if event.type == "receive" then
            local data = ser.d(event.data)[1]
            local uid = event.peer:index()

            if data.event == 'move' then
                local dx = 1 * (data.x == 0 and 0 or data.x > 0 and 1 or -1)
                local dy = 1 * (data.y == 0 and 0 or data.y > 0 and 1 or -1)
                local position = entities[uid].position
                local player = entities[uid].player

                position.x, position.y, collisions, count =
                    world:move(uid, position.x + dx, position.y + dy)

                for c = 1, count do
                    local other = collisions[c].other

                    if type(other) == 'table' then
                        if other.type == 'egg' and other.team ~= player.team then
                            player.hasEgg = true
                            queue[#queue + 1] =
                                {
                                    type = 'capture',
                                    uid = uid,
                                    teams = teams,
                                    entities = entities
                                }

                        elseif other.type == 'chick' and other.team ==
                            player.team and teams[player.team].carrier == uid then
                            player.hasEgg = false

                            teams[player.team].score =
                                teams[player.team].score + 1

                            queue[#queue + 1] =
                                {
                                    type = 'goal',
                                    uid = uid,
                                    teams = teams,
                                    entities = entities
                                }
                        end
                    end
                end

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
                    if i ~= uid and entity.player.team ~=
                        entities[uid].player.team then
                        local ex, ey = entity.position.x, entity.position.y

                        local da = math.atan2(py - ey, px - ex)
                        local dex = math.cos(da) * 16
                        local dey = math.sin(da) * 16

                        local hx = data.dx + dex
                        local hy = data.dy + dey

                        local hit = math.abs(hx) < 10 and math.abs(hy) < 10

                        if math.distance(px, py, ex, ey) < 32 and hit then
                            entity.hearts.hp = entity.hearts.hp - 1

                            if entity.hearts.hp == 0 then
                                world:update(i, 120, 260)
                                entities[i] =
                                    {
                                        ping = event.peer:round_trip_time(),
                                        position = {x = 120, y = 260},
                                        size = {w = 16, h = 16},
                                        player = {
                                            team = entity.player.team,
                                            hasEgg = false
                                        },
                                        sprite = {
                                            name = 'player',
                                            color = teamColor[entity.player.team],
                                            scale = 1
                                        },
                                        hearts = {hp = 3}
                                    }
                                queue[#queue + 1] =
                                    {type = 'move', entities = entities}
                            else
                                queue[#queue + 1] =
                                    {
                                        type = 'hit',
                                        uid = i,
                                        hp = entity.hearts.hp
                                    }
                                entities[uid].position.x =
                                    entities[uid].position.x +
                                        math.random(-5, 5)
                                entities[uid].position.y =
                                    entities[uid].position.y +
                                        math.random(-5, 5)
                                queue[#queue + 1] =
                                    {type = 'move', entities = entities}
                            end
                        end
                    end
                end

            end
        elseif event.type == "connect" then
            local uid = event.peer:index()
            print("connected: ", event.peer, uid)
            local team = teams.red.players < teams.blue.players and 'red' or
                             'blue'
            teams[team].players = teams[team].players + 1

            entities[uid] = {
                ping = event.peer:round_trip_time(),
                position = {x = 120, y = 260},
                size = {w = 16, h = 16},
                player = {team = team, hasEgg = false},
                sprite = {name = 'player', color = teamColor[team], scale = 1},
                hearts = {hp = 3}
            }

            local position = entities[uid].position
            local size = entities[uid].size

            world:add(uid, position.x, position.y, size.w, size.h)

            event.peer:send(ser.s{
                type = 'connect',
                uid = uid,
                entities = entities,
                teams = teams
            })

            queue[#queue + 1] = {
                type = 'spawn',
                data = entities[uid],
                uid = uid
            }

        elseif event.type == "disconnect" then
            local uid = event.peer:index()
            print(dump(entities[uid]))

            teams[entities[uid].player.team].players =
                teams[entities[uid].player.team].players - 1

            entities[uid] = nil

            world:remove(uid)

            queue[#queue + 1] = {type = 'despawn', uid = uid}

            print("disconnected: ", event.peer, uid)
        end
        event = host:service()
    end

    host:broadcast(ser.s{type = 'queue', queue = queue})
end
