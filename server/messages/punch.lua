return function(uid, peer, event)
    game.queueLossy[#game.queueLossy + 1] =
        {
            type = 'punch',
            uid = uid,
            dx = event.dx,
            dy = event.dy,
            angle = event.angle
        }
    local px, py = game.entities[uid].position.x, game.entities[uid].position.y

    for i, entity in pairs(game.entities) do
        if i ~= uid and entity.player.team ~= game.entities[uid].player.team then
            local ex, ey = entity.position.x, entity.position.y

            local da = math.atan2(py - ey, px - ex)
            local dex = math.cos(da) * 16
            local dey = math.sin(da) * 16

            local hx = event.dx + dex
            local hy = event.dy + dey

            local hit = math.abs(hx) < 10 and math.abs(hy) < 10

            if math.distance(px, py, ex, ey) < 32 and hit then
                entity.hearts.hp = entity.hearts.hp - 1

                if entity.hearts.hp <= 0 then
                    if entity.player.hasEgg then
                        game.teams[entity.player.team].capturing = false
                        game.queueReliable[#game.queueReliable + 1] =
                            {
                                type = 'restore',
                                uid = uid,
                                teams = game.teams,
                                capturedTeam = entity.player.team == 'blue' and
                                    'red' or 'blue'
                            }
                    end
                    game.world:update(i, game.teamSpawn[entity.player.team].x,
                                      game.teamSpawn[entity.player.team].y)
                    game.entities[i] = {
                        ping = peer:round_trip_time(),
                        position = {
                            x = game.teamSpawn[entity.player.team].x,
                            y = game.teamSpawn[entity.player.team].y
                        },
                        size = {w = 16, h = 16},
                        player = {team = entity.player.team, hasEgg = false},
                        sprite = {
                            name = 'player',
                            color = game.teamColor[entity.player.team],
                            scale = 1
                        },
                        hearts = {hp = 3}
                    }
                    game.queueReliable[#game.queueReliable + 1] =
                        {type = 'death', killer = uid, killee = i}
                else
                    game.queueReliable[#game.queueReliable + 1] =
                        {type = 'hit', uid = i, hp = entity.hearts.hp}
                    game.entities[i].position.x =
                        game.entities[i].position.x + love.math.random(-5, 5)
                    game.entities[i].position.y =
                        game.entities[i].position.y + love.math.random(-5, 5)
                end
            end
        end
    end
end
