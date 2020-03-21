-- lolol spriteshits
local shits = {
    size   = 0,  -- cell size
    image  = {}, -- the image
    atlas  = {}, -- the image but sliced into pieces
    names  = {}, -- mapping quads to names
}

function shits:load(path, size)
    self.image = love.graphics.newImage(path)

    local w, h = self.image:getWidth() / size, self.image:getHeight() / size

    for x = 0, w do
        local row = {}

        for y = 0, h do
            row[y] = love.graphics.newQuad(x * size + x, y * size + y, size, size, self.image:getDimensions())
        end

        self.atlas[x] = row
    end

    return self
end

function shits:name(x, y, name)
    self.names[name] = self.atlas[x][y]
end

function shits:get(name)
    return self.names[name]
end

return shits