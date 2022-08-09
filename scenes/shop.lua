local shop = {}

local viewport = require("ui.viewport")
local background = require("ui.background")

local button = require("ui.elements.button")
local ba = require("graphics.sprites").button_atlas
local baw,bah = ba:getDimensions()

local upgrades = require("player.upgrades")
local text = require("ui.elements.text")
local pages = {
   require("ui.shop.page1")
}


local currentPage = 1


function  shop.update(dt)
    background.update(dt)
end

local music = require("audio.music")
local musicVolume = 0
local musicPrevol
function  shop.init()
    musicVolume = 0
    musicPrevol = music.source:getVolume()
end

local gamestate = require("gamestate")


function  shop.draw()
    viewport.beginRender()
    background.draw()

    for i,v in ipairs(pages[currentPage]) do
        v:draw()
    end

    

    love.graphics.print(gamestate.player.money,62-text.font:getWidth(tostring(gamestate.player.money)),2)
    viewport.endRender()
    viewport.draw()
end

function  shop.update(dt)
    musicVolume = musicVolume+dt
    local vol = math.min(music.volume,math.max(music.volume * .2,musicPrevol-math.lerpc(0,music.volume*.95,musicVolume)))
    music.source:setFilter(
        {type = "lowpass",
        volume = music.volume,
        highgain = .6
        }
    )
    music.source:setVolume(vol)
end
function  shop.exit()
    music.source:setFilter()
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