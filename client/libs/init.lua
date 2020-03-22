local path = "libs/"

local camera    = require(path .. "camera")
local gamestate = require(path .. "gamestate")
local bump      = require(path .. "bump")
local baton     = require(path .. "baton")
local ecs       = require(path .. "ecs")
local shits     = require(path .. "shits")
local shack     = require(path .. "shack")


return {
    camera    = camera,
    gamestate = gamestate,
    bump      = bump,
    baton     = baton,
    ecs       = ecs,
    shits     = shits,
    shack     = shack,
}