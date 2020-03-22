require "libs/autobatch"

require "utils"
libs = require "libs"

local gamestate = libs.gamestate
local game      = require "game"

love.graphics.setBackgroundColor(120 / 255, 239 / 255, 255 / 255)

function love.load()
    gamestate.registerEvents()
    gamestate.switch(game)
end
