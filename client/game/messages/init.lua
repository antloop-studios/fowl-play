local m = 'game.messages.'
return {
    connect = require(m .. "connect"),
    spawn = require(m .. "spawn"),
    despawn = require(m .. "despawn"),
    move = require(m .. "move"),
    hit = require(m .. "hit"),
    punch = require(m .. "punch"),
    capture = require(m .. "capture"),
    goal = require(m .. "goal"),
    restore = require(m .. "restore"),
    death = require(m .. "death")
}
