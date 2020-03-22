require "libs/autobatch"

require "utils"
libs = require "libs"

local gamestate = libs.gamestate
local game      = require "game"

love.graphics.setBackgroundColor(23 / 200, 67 / 200, 84 / 200)

config = {
    server = "fowl.antloop.world:5700"
}

function love.load(args)
    if args[1] == 'local' then
        config.server = "localhost:5700"
    end

    gamestate.registerEvents()
    gamestate.switch(game)
end
