return function(uid, peer, event)
    print("connected: ", event.peer, uid)

    local team = game.teams.red.players < game.teams.blue.players and 'red' or
                     'blue'
    game.teams[team].players = game.teams[team].players + 1

    game.entities[uid] = {
        ping = event.peer:round_trip_time(),
        position = {x = game.teamSpawn[team].x, y = game.teamSpawn[team].y},
        size = {w = 16, h = 16},
        player = {team = team, hasEgg = false},
        sprite = {name = 'player', color = game.teamColor[team], scale = 1},
        hearts = {hp = 3}
    }

    local position = game.entities[uid].position
    local size = game.entities[uid].size

    game.world:add(uid, position.x, position.y, size.w, size.h)

    event.peer:send(ser.s{
        type = 'connect',
        uid = uid,
        entities = game.entities,
        teams = game.teams
    })

    game.queueReliable[#game.queueReliable + 1] =
        {type = 'spawn', data = game.entities[uid], uid = uid}
end
