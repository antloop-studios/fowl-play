return function(self, event)
    self.teams = event.teams
    game:send_log(event.capturedTeam .. " egg is being carried away!")

    if event.capturedTeam == game.entities[game.uid].e.player.team then
        game.audio.warning[love.math.random(#game.audio.warning)]:play()
    else
        game.audio.ding[love.math.random(#game.audio.ding)]:play()
    end
end
