local level = {
    size = 20,
    registry = {
        block  = {0, 0, 0},
        player = {0, 1, 0}
    },
    map = {}
}

local uid = 100000

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

function level:spawn(k, x, y)
    if k == "block" then
        local conf = {
            position = {x = x, y = y},
            size     = {w = 20, h = 20},
            color    = {0, 0, 0}
        }

        -- local id = e.block(conf)
        uid = uid + 1
        world:add(uid, x, y, conf.size.w, conf.size.h)
    end

    -- if k == "player" then
    --     local conf = {
    --         position = {x = x, y = y},
    --         size     = {w = 20, h = 20},
    --         color    = {0, 1, 0},
    --         player   = {}
    --     }

        -- local id = e.player(conf)

        -- game.world:add(id, x, y, conf.size.w, conf.size.h)
    -- end
end

return level
