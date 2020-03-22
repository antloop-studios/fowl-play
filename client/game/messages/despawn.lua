return function(self, event)
    e.delete(self.entities[event.uid].id)
    self.entities[event.uid] = nil
end
