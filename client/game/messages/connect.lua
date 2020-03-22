return function(self, event)
    print('connect', event.uid)
    self.uid = event.uid

    for i, entity in pairs(event.entities) do
        local id, ping
        if i ~= self.uid then
            local color = entity.sprite.color
            entity.sprite = {name = "player", color = color, scale = 1}
            ping = entity.ping
            entity.ping = nil
            id = e.player(entity)
        end
        self.entities[i] = {e = e.get(id), id = id, ping = ping}
    end

    game:send_log("[server] player joined the game", {0, 1, 0})
    self.teams = event.teams
end
