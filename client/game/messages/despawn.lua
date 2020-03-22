return function(self, event)
    e.delete(self.entities[event.uid].id)
    self.entities[event.uid] = nil

    game:send_log("[server] player left the game", { 1, 0, 0})
end
