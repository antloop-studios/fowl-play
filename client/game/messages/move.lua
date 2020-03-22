return function(self, event)
    for i, entity in pairs(event.entities) do
        if self.entities[i] then
            self.entities[i].ping = entity.ping
            self.entities[i].e.position.x = entity.position.x
            self.entities[i].e.position.y = entity.position.y
            self.entities[i].e.hearts.hp = entity.hearts.hp
            self.entities[i].e.player.hasEgg = entity.player.hasEgg
        end
    end
end
