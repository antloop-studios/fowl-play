require "utils"
libs = require "libs"

local gamestate = libs.gamestate
local game      = require "game"

love.graphics.setBackgroundColor(1, 1, 1)

function love.load()
    gamestate.registerEvents()
    gamestate.switch(game)
end
