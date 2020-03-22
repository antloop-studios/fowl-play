return function(self, event)
    game:send_log("[server] " .. self.entities[event.uid].e.player.team ..
                      " player left the game", {1, 0, 0})

    e.delete(self.entities[event.uid].id)
    self.entities[event.uid] = nil
end
