local m = 'messages.'
return {
    connect = require(m .. "connect"),
    disconnect = require(m .. "disconnect"),
    move = require(m .. "move"),
    punch = require(m .. "punch")
}
