local path = "libs/"

local camera    = require(path .. "camera")
local gamestate = require(path .. "gamestate")
local bump      = require(path .. "bump")
local baton     = require(path .. "baton")
local ecs       = require(path .. "ecs")

return {
    camera    = camera,
    gamestate = gamestate,
    bump      = bump,
    baton     = baton,
    ecs       = ecs,
}