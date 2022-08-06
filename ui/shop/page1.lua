local ba = require("graphics.sprites").button_atlas
local baw,bah = ba:getDimensions()

local q = love.graphics.newQuad
local button = require("ui.elements.button")
local text = require("ui.text")
local auguments = require("player.upgrades.auguments")

local function purchase()
    if auguments.purchase("cannon_firerate") then
        
    end
end

local page = {
    button.new(ba,{q(0,11,10,10,baw,bah),q(11,11,10,10,baw,bah)},28,15,10,10,purchase),
    button.new(ba,{q(0,11,10,10,baw,bah),q(11,11,10,10,baw,bah)},28,27,10,10),
    button.new(ba,{q(0,11,10,10,baw,bah),q(11,11,10,10,baw,bah)},28,39,10,10),
    button.new(ba,{q(0,11,10,10,baw,bah),q(11,11,10,10,baw,bah)},28,51,10,10),


    text.new(auguments.gun_damage:price(),56,17)
}


return page