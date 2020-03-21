libs = require "libs"

local gamestate = libs.gamestate

local game = require "game"

function love.load()
    gamestate.registerEvents()
    gamestate.switch(game)
end