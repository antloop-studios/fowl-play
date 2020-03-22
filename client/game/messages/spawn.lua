return function(self, event)
    print('spawn', event.uid)
    local id, ping
    if event.uid == self.uid then
        local color = event.data.sprite.color
        event.data.sprite = {name = "player", color = color, scale = 1}
        event.data.controller = {}
        event.data.pointer = {angle = 0, radius = 16}
        ping = event.data.ping
        event.data.ping = nil
        id = e.cplayer(event.data)
    else
        local color = event.data.sprite.color
        event.data.sprite = {name = "player", color = color, scale = 1}
        ping = event.data.ping
        event.data.ping = nil
        id = e.player(event.data)
    end
    self.entities[event.uid] = {e = e.get(id), id = id, ping = ping}
end
