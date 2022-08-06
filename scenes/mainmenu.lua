local mainmenu = {}
local buttonSprite = love.graphics.newImage("graphics/menus/play_button.png")
local state = require("util.state")
local iw,ih = buttonSprite:getWidth(),buttonSprite:getHeight()

local habitat = require("entities.habitat").new()
local button = require("ui.elements.button")


local buttons = {
        button.new(
        buttonSprite,
        {love.graphics.newQuad(0,0,48,16,iw,ih),love.graphics.newQuad(0,17,48,16,iw,ih)},
        8,16,48,16,
        function ()
            state.set("game",habitat);
        end)
}

local background = require("ui.background")


function  mainmenu.update(dt)
    background.update(dt)
    habitat:animate(dt)
end

local viewport = require("ui.viewport")





function mainmenu.draw()
    viewport.beginRender()
    background.draw()
    for i,v in ipairs(buttons) do
        v:draw()
    end
    
    habitat:draw()
    viewport.endRender()
    viewport.draw()
end

function  mainmenu.mousepressed(x,y,b)
    if b == 1 then
        
    x,y = viewport.translate(x,y)
    for i,v in ipairs(buttons) do
        v:clicked(x,y)
    end
end
end



function  mainmenu.mousereleased(x,y,b)
    if b == 1 then
        x,y = viewport.translate(x,y)
        for i,v in ipairs(buttons) do
            v:released(x,y)
        end
    end
end

return mainmenu