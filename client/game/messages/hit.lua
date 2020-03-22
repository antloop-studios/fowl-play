return function(self, event)
    if event.uid == self.uid then
        libs.shack:setShake(20)
        self.hit = true
    end
    game.audio.punch[love.math.random(#game.audio.punch)]:play()
    self.entities[event.uid].e.hearts.hp = event.hp
end
