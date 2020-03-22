require "libs/autobatch"

require "utils"
libs = require "libs"

local gamestate = libs.gamestate
local game      = require "game"

love.graphics.setBackgroundColor(120 / 255, 239 / 255, 255 / 255)

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
