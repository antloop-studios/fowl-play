return function(uid, peer, event)
    game.teams[game.entities[uid].player.team].players =
        game.teams[game.entities[uid].player.team].players - 1
    game.entities[uid] = nil
    game.world:remove(uid)

    game.queueReliable[#game.queueReliable + 1] = {type = 'despawn', uid = uid}

    print("disconnected: ", event.peer, uid)
end
