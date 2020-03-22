require "libs/autobatch"

require "utils"
libs = require "libs"

local gamestate = libs.gamestate
local game = require "game"

love.graphics.setBackgroundColor(27.8 / 200, 17.6 / 200, 23.5 / 200)

config = {server = "fowl2.antloop.world:5700"}

function love.load(args)
    if args[1] == 'local' then config.server = "localhost:5700" end

    gamestate.registerEvents()
    gamestate.switch(game)
end
