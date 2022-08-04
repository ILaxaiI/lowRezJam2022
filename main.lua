love.graphics.setDefaultFilter("nearest","nearest")
local state = require("util.state")
state.load("scenes.game","game")
state.load("scenes.game","game")


state.set("game")

function  love.draw()
    state.draw()
end

function  love.update(dt)
    state.update(dt)
end

function  love.keypressed(key)
    state.keypressed(key)
end

function  love.mousereleased(x,y,b)
    state.mousereleased(x,y,b)
end

function  love.wheelmoved(dx,dy)
    state.wheelmoved(dx,dy)
end

