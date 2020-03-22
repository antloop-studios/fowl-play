return function(self, event)
    if event.uid == self.uid then
        libs.shack:setShake(20)
        self.hit = true
        self.entities[event.uid].e.player.life = event.life
    end
end
