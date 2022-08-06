love.graphics.setDefaultFilter("nearest","nearest")

local viewport = require("ui.viewport")
viewport.scale = viewport.getScale()
viewport.offsetx,viewport.offsety = viewport.getOffset()



local state = require("util.state")
state.load("scenes.game","game")
state.load("scenes.mainmenu","mainmenu")
state.load("scenes.shop","shop")
state.load("scenes.gameOver","gameOver")



state.set("mainmenu")
--state.set("shop")

function  love.draw()
    state.draw()
    
    love.graphics.print(love.timer.getFPS())
end

function  love.update(dt)
    state.update(dt)
end

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
    print(love.graphics.getWidth(),love.graphics.getHeight())
    viewport.scale = viewport.getScale()
    viewport.offsetx,viewport.offsety = viewport.getOffset()
end