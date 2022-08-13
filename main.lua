love.graphics.setDefaultFilter("nearest","nearest")


require("ui.elements.text")

function  math.lerp(a,b,t)
    return (a * (1.0 - t)) + (b * t)
end
function math.lerpc (a, b, t)
    return math.max(a,math.min(b,math.lerp(a,b,t)))
end



local viewport = require("ui.viewport")
viewport.scale = viewport.getScale()
viewport.offsetx,viewport.offsety = viewport.getOffset()

local settings = require("settings")
settings:load()

local state = require("util.state")
state.load("scenes.game","game")
state.load("scenes.mainmenu","mainmenu")
state.load("scenes.shop","shop")
state.load("scenes.gameOver","gameOver")
state.load("scenes.options","options")



state.set("mainmenu")
--state.set("shop")

function  love.draw()
    state.draw()
    love.graphics.print(love.timer.getFPS())
end

function  love.update(dt)
    dt = math.min(dt,1/60)
    state.update(dt)
end
local music = require("audio.music")

local filter = true
function  love.keypressed(key)

    state.keypressed(key)
end

function  love.mousepressed(x,y,b)
    state.mousepressed(x,y,b)
end
function  love.mousereleased(x,y,b)
    state.mousereleased(x,y,b)
end

function  love.wheelmoved(dx,dy)
    state.wheelmoved(dx,dy)
end


function  love.resize()
    viewport.scale = viewport.getScale()
    viewport.offsetx,viewport.offsety = viewport.getOffset()
end