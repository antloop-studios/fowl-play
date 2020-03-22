return function(self, event)
    print('connect', event.uid)
    self.uid = event.uid
    for i, entity in pairs(event.entities) do
        local id, ping
        if i ~= self.uid then
            ping = entity.ping
            entity.ping = nil
            id = e.player(entity)
        end
        self.entities[i] = {e = e.get(id), id = id, ping = ping}
    end

    self.teams = event.teams
end
