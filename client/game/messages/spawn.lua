return function(self, event)
    print('spawn', event.uid)
    local id
    if event.uid == self.uid then
        event.data.sprite = {
            name = "player",
            color = {84 / 200, 81 / 200, 75 / 200},
            scale = 1
        }
        event.data.controller = {}
        event.data.pointer = {angle = 0, radius = 16}
        event.data.hearts = {hp = 3}
        id = e.cplayer(event.data)
    else
        event.data.sprite = {name = "player", color = {0, 1, 0}, scale = 1}
        event.data.ping = nil
        event.data.hearts = {hp = 3}
        id = e.player(event.data)
    end
    self.entities[event.uid] = {e = e.get(id), id = id}
end
