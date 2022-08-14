local mainmenu = {}
local buttonSprite = require("graphics.sprites").play_button
local state = require("util.state")
local iw,ih = buttonSprite:getWidth(),buttonSprite:getHeight()

local habitat 
local button = require("ui.elements.button")
local gamestate = require("gamestate")

local sb = require("graphics.sprites").button_atlas
local iw2,ih2 = sb:getWidth(),sb:getHeight()

local music = require("audio.music")
function mainmenu.init()
    music["intro"]:play()
    habitat = require("entities.habitat"):new()
end

function  mainmenu.exit()
end

local buttons = {
    button:new(
    buttonSprite,
    {love.graphics.newQuad(0,0,48,16,iw,ih),love.graphics.newQuad(0,17,48,16,iw,ih)},
    8,16,48,16,
    function ()
        state.set("game",habitat);
    end),
    button:new(
    sb,
    {love.graphics.newQuad(22,22,10,10,iw2,ih2),love.graphics.newQuad(33,22,10,10,iw2,ih2)},
    8,33,10,10,
    function ()
        state.set("options","mainmenu");
    end),
    button:new(
    sb,
    {love.graphics.newQuad(22,11,10,10,iw2,ih2),love.graphics.newQuad(33,11,10,10,iw2,ih2)},
    46,33,10,10,
    function ()
        love.event.quit()
    end)
}

local background = require("ui.background")

local music = require("audio.music")

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