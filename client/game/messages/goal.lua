return function(self, event)
    self.teams = event.teams
    game:send_log(event.capturedTeam .. " egg was captured!")
end
