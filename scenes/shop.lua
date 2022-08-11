local shop = {}
shop.__index = shop
local viewport = require("ui.viewport")
local background = require("ui.background")

local button = require("ui.elements.button")
local ba = require("graphics.sprites").button_atlas
local baw,bah = ba:getDimensions()

local upgrades = require("player.upgrades")
local text = require("ui.elements.text")
local gamestate = require("gamestate")

local pages = {
    require("ui.shop.page1"),
    require("ui.shop.cannon_upgrades"),
    require("ui.shop.shield_upgrades"),
    require("ui.shop.antimatter_upgrades"),
    require("ui.shop.habitat_upgrades"),
}

function  shop.update(dt)
    background.update(dt)
end

local music = require("audio.music")
local musicVolume = 0
local musicPrevol
function  shop.init()
    gamestate.shop:reset()
    musicVolume = 0
    musicPrevol = music.source:getVolume()
end

local state = require("util.state")
    local backsprite = love.graphics.newImage("graphics/menus/shop_bg.png")



    local ndisp = require("player.money_display")
function  shop.draw()
    viewport.beginRender()
    background.draw()
    love.graphics.draw(backsprite)
    pages[gamestate.shop.currentPage]:draw()

    ndisp:draw()
    viewport.endRender()
    viewport.draw()
end

function  shop.update(dt)
    ndisp:update(dt)
    ndisp.n = tostring(gamestate.player.money)
    musicVolume = musicVolume+dt
    local vol = math.min(music.volume,math.max(music.volume * .2,musicPrevol-math.lerpc(0,music.volume*.95,musicVolume)))
    music.source:setFilter(
        {type = "lowpass",
        volume = music.volume,
        highgain = .6
        }
    )
    
    pages[gamestate.shop.currentPage]:update(dt)
    music.source:setVolume(vol)
end
function  shop.exit()
    music.source:setFilter()
end

function  shop.mousepressed(x,y,b)
    if b == 1 then
        
    x,y = viewport.translate(x,y)
        pages[gamestate.shop.currentPage]:clicked(x,y,b)

    end
end



function  shop.mousereleased(x,y,b)
    if b == 1 then
        
        x,y = viewport.translate(x,y)
        pages[gamestate.shop.currentPage]:released(x,y,b)
    end
end

function  shop.keypressed(key)
    if key =="escape" then gamestate.shop:back() end
end

return shop