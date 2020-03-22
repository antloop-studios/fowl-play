return function(self, event)
    self.teams = event.teams
    game:send_log(event.capturedTeam .. " egg has been recovered!")
end
