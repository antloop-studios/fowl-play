local m = 'game.messages.'
return {
    connect = require(m .. "connect"),
    spawn = require(m .. "spawn"),
    despawn = require(m .. "despawn"),
    move = require(m .. "move"),
    hit = require(m .. "hit"),
    punch = require(m .. "punch")
}
