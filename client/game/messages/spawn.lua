return function(self, event)
    print('spawn', event.uid)

    local id, ping

    if event.uid == self.uid then
        event.data.controller = {}
        event.data.pointer = {angle = 0, radius = 16}
        ping = event.data.ping
        event.data.ping = nil
        id = e.cplayer(event.data)
    else
        ping = event.data.ping
        event.data.ping = nil
        id = e.player(event.data)
    end

    self.entities[event.uid] = {e = e.get(id), id = id, ping = ping}

    game:send_log("[server] " .. event.data.player.team ..
                      " player joined the game", {0, 1, 0})
end
