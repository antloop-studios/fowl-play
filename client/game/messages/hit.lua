return function(self, event)
    if event.uid == self.uid then
        libs.shack:setShake(20)
        self.hit = true
    end
    self.entities[event.uid].e.hearts.hp = event.hp
end
