return function(self, event)
    for i, entity in pairs(event.entities) do
        if self.entities[i] then
            self.entities[i].ping = entity.ping
            self.entities[i].e.position.x = entity.position.x
            self.entities[i].e.position.y = entity.position.y
        end
    end
end
