return function(self, event)
    self.teams = event.teams
    game:send_log(event.capturedTeam .. " egg was captured!")

    if event.capturedTeam == game.entities[game.uid].e.player.team then
        game.audio.loss[love.math.random(#game.audio.loss)]:play()
    else
        game.audio.win[love.math.random(#game.audio.win)]:play()
    end

end
