local shop = {}

local viewport = require("ui.viewport")
local background = require("ui.background")

local button = require("ui.elements.button")
local ba = require("graphics.sprites").button_atlas
local baw,bah = ba:getDimensions()

local upgrades = require("player.upgrades.auguments")
local text = require("ui.text")
local pages = {
   require("ui.shop.page1")
}


local currentPage = 1


function  shop.update(dt)
    background.update(dt)
end


local gamestate = require("gamestate")

function  shop.draw()
    viewport.beginRender()
    background.draw()

    for i,v in ipairs(pages[currentPage]) do
        v:draw()
    end
    
    text.printNumber(gamestate.player.money,62,2)
    viewport.endRender()
    viewport.draw()
end


function  shop.update(dt)
    
end

function  shop.mousepressed(x,y,b)
    if b == 1 then
    x,y = viewport.translate(x,y)
    for i,v in ipairs(pages[currentPage]) do
        if v.clicked then v:clicked(x,y) end
    end
end
end



function  shop.mousereleased(x,y,b)
    if b == 1 then
        x,y = viewport.translate(x,y)
        for i,v in ipairs(pages[currentPage]) do
            if v.released then v:released(x,y) end
        end
    end
end

local state = require("util.state")
function  shop.keypressed(key)
    if key =="escape" then state.set("game") end
end

return shop