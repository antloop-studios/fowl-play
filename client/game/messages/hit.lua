return function(self, event)
    if event.uid == self.uid then
        libs.shack:setShake(20)
        self.hit = true
        self.entities[event.uid].e.hearts.hp =
            self.entities[event.uid].e.hearts.hp - 1
    end
end
