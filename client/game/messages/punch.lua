return function(self, event)
    if event.uid ~= self.uid then
        local position = self.entities[event.uid].e.position
        local size = self.entities[event.uid].e.size

        e.punch{
            position = {
                x = position.x + size.w / 2,
                y = position.y + size.h / 2
            },
            size = {w = 16, h = 16},
            punch = {angle = event.angle, scale = 1}
        }
    end
end
