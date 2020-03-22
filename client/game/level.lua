local level = {
    size = 16,
    registry = {
        block  = {0, 0, 0},
        player = {0, 1, 0},
        dirt   = {1, 1, 1}
    },
    map = {}
}

function level:load(path)
    local image = love.image.newImageData(path)
    local map = {}

    for x = 1, image:getWidth() do
        map[x] = {}

        for y = 1, image:getHeight() do
            local rx, ry = x - 1, y - 1

            local r, g, b = image:getPixel(rx, ry)

            for k, v in pairs(self.registry) do
                if math.fuzzy_equals(r, v[1], 0.01) and math.fuzzy_equals(g, v[2], 0.01) and math.fuzzy_equals(b, v[3], 0.01) then
                    self:spawn(k, self.size * rx, self.size * ry)
                end
            end
        end
    end
end

function level:make_dirt(x, y)
    local conf = {
        position = {x = x, y = y},
        size     = {w = self.size, h = self.size},
        color    = { 27.8 / 200, 17.6 / 200, 23.5 / 200 }
    }

    local id = e.dirt(conf)
end

function level:spawn(k, x, y)
    if k == "block" then
        local conf = {
            position = {x = x, y = y},
            size     = {w = self.size, h = self.size},
            sprite   = { name = "tree", color = { 22 / 200, 85 / 200, 45 / 200 }, scale = 1.5 }
        }

        local id = e.block(conf)

        self:make_dirt(x, y)
    end

    if k == "dirt" or k == "player" then
        self:make_dirt(x, y)
    end
end

return level
