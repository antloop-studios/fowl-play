return function(uid, peer, event)
    local dx = 1 * (event.x == 0 and 0 or event.x > 0 and 1 or -1)
    local dy = 1 * (event.y == 0 and 0 or event.y > 0 and 1 or -1)
    local position = game.entities[uid].position
    local player = game.entities[uid].player
    local collisions, count

    position.x, position.y, collisions, count =
        game.world:move(uid, position.x + dx, position.y + dy)

    for c = 1, count do
        local other = collisions[c].other

        if type(other) == 'table' then
            if other.type == 'egg' and other.team ~= player.team and
                not player.hasEgg and not game.teams[player.team].capturing then

                player.hasEgg = true
                game.teams[player.team].capturing = true

                game.queueReliable[#game.queueReliable + 1] =
                    {
                        type = 'capture',
                        uid = uid,
                        teams = game.teams,
                        capturedTeam = other.team
                    }

            elseif other.type == 'chick' and other.team == player.team and
                player.hasEgg then

                player.hasEgg = false
                game.teams[player.team].capturing = false

                game.teams[player.team].score =
                    game.teams[player.team].score + 1

                game.queueReliable[#game.queueReliable + 1] =
                    {
                        type = 'goal',
                        uid = uid,
                        teams = game.teams,
                        capturedTeam = other.team == 'blue' and 'red' or 'blue'
                    }
            end
        end
    end

    game.entities[uid].ping = peer:round_trip_time()

    game.queueLossy[#game.queueLossy + 1] =
        {type = 'move', entities = game.entities}

end
