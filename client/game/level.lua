local level = {
    size = 16,
    registry = {
        block = {0, 0, 0},
        player = {0, 1, 0},
        dirt = {1, 1, 1},
        chicken_blu = {0, 0, 1},
        chicken_red = {1, 0, 0},
        egg_red = {1, 1, 0},
        egg_blu = {0, 1, 1}
    },
    map = {}
}

local tree_colors = {
    {25 / 200, 88 / 200, 48 / 200}, -- light
    {22 / 200, 85 / 200, 45 / 200}, {16 / 200, 79 / 200, 39 / 200} -- less light
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
                if math.fuzzy_equals(r, v[1], 0.01) and
                    math.fuzzy_equals(g, v[2], 0.01) and
                    math.fuzzy_equals(b, v[3], 0.01) then
                    self:spawn(k, self.size * rx, self.size * ry)
                end
            end
        end
    end
end

function level:make_dirt(x, y)
    local conf = {
        position = {x = x, y = y},
        size = {w = self.size, h = self.size},
        color = {27.8 / 200, 17.6 / 200, 23.5 / 200}
    }

    local id = e.dirt(conf)
end

function level:spawn(k, x, y)
    if k == "block" then
        local conf = {
            position = {x = x, y = y},
            size = {w = self.size, h = self.size},
            sprite = {
                name = "tree" .. math.random(1, 3),
                color = tree_colors[math.random(1, #tree_colors)],
                scale = 1
            }
        }

        local id = e.block(conf)

        self:make_dirt(x, y)
    end

    if k == "dirt" or k == "player" then self:make_dirt(x, y) end

    if k == "chicken_blu" then
        local conf = {
            position = {x = x + self.size / 2, y = y},
            size = {w = self.size, h = self.size},
            sprite = {name = "chick", color = {0.1, 0.1, 0.5}, scale = 2},
            chicken = {team = 'blue'}
        }

        local id = e.chicken(conf)

        self:make_dirt(x, y)
    end

    if k == "chicken_red" then
        local conf = {
            position = {x = x + self.size / 2, y = y},
            size = {w = self.size, h = self.size},
            sprite = {name = "chick", color = {0.5, 0, 0}, scale = 2},
            chicken = {team = 'red'}
        }

        local id = e.chicken(conf)

        self:make_dirt(x, y)
    end

    if k == "egg_red" then
        local conf = {
            position = {x = x, y = y},
            size = {w = self.size, h = self.size},
            sprite = {name = "egg", color = {0.8, 0.2, 0.2}, scale = 1},
            egg = {team = 'red'}
        }

        local id = e.egg(conf)

        self:make_dirt(x, y)
    end

    if k == "egg_blu" then
        local conf = {
            position = {x = x, y = y},
            size = {w = self.size, h = self.size},
            sprite = {name = "egg", color = {0.2, 0.2, 0.8}, scale = 1},
            egg = {team = 'blue'}
        }

        local id = e.egg(conf)

        self:make_dirt(x, y)
    end

end

return level
