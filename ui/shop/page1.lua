local ba = require("graphics.sprites").button_atlas
local baw,bah = ba:getDimensions()

local q = love.graphics.newQuad
local button = require("ui.elements.button")
local mtext = require("ui.elements.money_display")
local text = require("ui.elements.text")
local auguments = require("player.upgrades")
local gamestate = require("gamestate")

local page = {}
local function setP()
    gamestate.shop.currentPage = 2
end
local buttons = {
    
    button:new(
    require("graphics.sprites").button_atlas,
    {love.graphics.newQuad(22,11,10,10,64,64),love.graphics.newQuad(33,11,10,10,64,64)},
    2,2,10,10,gamestate.shop.back,gamestate.shop),

    button:new(ba,{q(0,22,10,10,baw,bah),q(11,22,10,10,baw,bah)},51,14,10,10,gamestate.shop.setPage,gamestate.shop,2),
    button:new(ba,{q(0,22,10,10,baw,bah),q(11,22,10,10,baw,bah)},51,25,10,10,gamestate.shop.setPage,gamestate.shop,3),
    button:new(ba,{q(0,22,10,10,baw,bah),q(11,22,10,10,baw,bah)},51,36,10,10,gamestate.shop.setPage,gamestate.shop,4),
    button:new(ba,{q(0,22,10,10,baw,bah),q(11,22,10,10,baw,bah)},51,50,10,10,gamestate.shop.setPage,gamestate.shop,5),
}
local text = {
    text:new("Cannon",4,15),
    text:new("Shield",4,26),
    text:new("Anti-Matter\nCannon",4,37),
    text:new("Habitat",4,52)
}

function page:update(dt)
    
end

function  page:draw(dt)
    for i,v in ipairs(buttons) do
        v:draw()
    end
    for i,v in ipairs(text) do
        v:draw()
    end
end

function  page:clicked(x,y,b)
    for i,v in ipairs(buttons) do
        v:clicked(x,y,b)
    end
end

function  page:released(x,y,b)
    for i,v in ipairs(buttons) do
        v:released(x,y,b)
    end
    
end

return page