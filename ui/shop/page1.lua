local ba = require("graphics.sprites").button_atlas
local baw,bah = ba:getDimensions()

local q = love.graphics.newQuad
local button = require("ui.elements.button")
local mtext = require("ui.elements.money_display")
local text = require("ui.elements.text")
local auguments = require("player.upgrades")
local gamestate = require("gamestate")


local displays = {
    purchase_cannon = mtext:new(tostring(auguments.purchase_cannon:price()),62,17),
    purchase_energy_shield = mtext:new(tostring(auguments.purchase_cannon:price()),62,28),
 --   gun_damage = mtext.new(auguments.gun_damage:price(),56,27)
}


local page

local function purchase(upgrade_name)
    if auguments.purchase(upgrade_name) then
        page[displays[upgrade_name].id] = page[#page]
        page[#page].id = displays[upgrade_name].id
        page[#page] = nil
    end
end



page = {
    button:new(ba,{q(0,11,10,10,baw,bah),q(11,11,10,10,baw,bah)},30,15,10,10,purchase,"purchase_cannon"),
    button:new(ba,{q(0,11,10,10,baw,bah),q(11,11,10,10,baw,bah)},30,27,10,10,purchase,"purchase_energy_shield"),
    button:new(ba,{q(0,11,10,10,baw,bah),q(11,11,10,10,baw,bah)},30,39,10,10),
    button:new(ba,{q(0,11,10,10,baw,bah),q(11,11,10,10,baw,bah)},30,51,10,10),
    text:new("Cannon",1,18),
    text:new("Shield",1,30)
}



for i,v in pairs(displays) do
    v.n = tostring(auguments[i]:price())
    v.id = #page+1
    page[#page+1] = v
end

return page