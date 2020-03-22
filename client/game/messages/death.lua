return function(self, event)
    local messages = {
        " cracked ", " beat to a pulp ", " killed ", " minced ", " ate "
    }

    game:send_log(event.killer .. messages[love.math.random(#messages)] ..
                      event.killee)

    game.audio.death[love.math.random(#game.audio.death)]:play()
end
