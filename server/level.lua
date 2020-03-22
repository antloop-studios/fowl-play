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
                if math.fuzzy_equals(r, v[1], 0.01) and
                    math.fuzzy_equals(g, v[2], 0.01) and
                    math.fuzzy_equals(b, v[3], 0.01) then
                    self:spawn(k, self.size * rx, self.size * ry)
                end
            end
        end
    end
end

function level:spawn(k, x, y)
    uid = uid + 1
    local conf

    if k == "block" then
        conf = {
            position = {x = x, y = y},
            size = {w = 16, h = 16},
            sprite = {name = "tree", color = {0, 1, 0}, scale = 1}
        }
    end

    if k == "chicken_blu" then
        local conf = {
            position = {x = x, y = y},
            size = {w = self.size, h = self.size},
            sprite = {name = "chick", color = {0.1, 0.1, 0.5}, scale = 2},
            chicken = {team = 1}
        }
        teamSpawn.blue = {
            x = conf.position.x + conf.size.w / 2,
            y = conf.position.y + conf.size.h / 2
        }
        world:add({type = 'chick', team = 'blue'}, x, y,
                  conf.size.w * conf.sprite.scale,
                  conf.size.h * conf.sprite.scale)
    end

    if k == "chicken_red" then
        local conf = {
            position = {x = x, y = y},
            size = {w = self.size, h = self.size},
            sprite = {name = "chick", color = {0.5, 0, 0}, scale = 2},
            chicken = {team = 0}
        }
        teamSpawn.red = {
            x = conf.position.x + conf.size.w / 2,
            y = conf.position.y + conf.size.h / 2
        }
        world:add({type = 'chick', team = 'red'}, x, y,
                  conf.size.w * conf.sprite.scale,
                  conf.size.h * conf.sprite.scale)
    end

    if k == "egg_red" then
        local conf = {
            position = {x = x, y = y},
            size = {w = self.size, h = self.size},
            sprite = {name = "egg", color = {0.8, 0.2, 0.2}, scale = 1},
            egg = {team = 'red'}
        }

        world:add({type = 'egg', team = 'red'}, x, y,
                  conf.size.w * conf.sprite.scale,
                  conf.size.h * conf.sprite.scale)
    end

    if k == "egg_blu" then
        local conf = {
            position = {x = x, y = y},
            size = {w = self.size, h = self.size},
            sprite = {name = "egg", color = {0.2, 0.2, 0.8}, scale = 1},
            egg = {team = 'blue'}
        }

        world:add({type = 'egg', team = 'blue'}, x, y,
                  conf.size.w * conf.sprite.scale,
                  conf.size.h * conf.sprite.scale)
    end

    if conf then
        world:add(uid, x, y, conf.size.w * conf.sprite.scale,
                  conf.size.h * conf.sprite.scale)
    end
end

return level
