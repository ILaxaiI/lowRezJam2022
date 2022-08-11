local page = {}
local gamestate = require("gamestate")

local button = require("ui.elements.button")
local money_display = require("ui.elements.money_display")
local button_atlas = require("graphics.sprites").button_atlas
local buttons = {
    button:new(
        button_atlas,
        {love.graphics.newQuad(22,11,10,10,64,64),love.graphics.newQuad(33,11,10,10,64,64)},
        2,2,10,10,gamestate.shop.back,gamestate.shop),
}
local upgrades = require("player.upgrades")


local upgrade_buttons = {
    button:new(
        button_atlas,
        {love.graphics.newQuad(22,0,10,10,64,64),love.graphics.newQuad(33,0,10,10,64,64)},
        51,17,10,10,upgrades.purchase,"player_health"
    ),
    button:new(
        button_atlas,
        {love.graphics.newQuad(22,0,10,10,64,64),love.graphics.newQuad(33,0,10,10,64,64)},
        51,34,10,10,upgrades.purchase,"player_speed"
    ),
    button:new(
        button_atlas,
        {love.graphics.newQuad(22,0,10,10,64,64),love.graphics.newQuad(33,0,10,10,64,64)},
        51,51,10,10,upgrades.purchase,"player_repair_drones"
    ),
  
}

local mdis = {
    player_health = money_display:new(upgrades.cannon_firerate:price(),29,20),
    player_repair_drones =   money_display:new(upgrades.cannon_damage:price(),29,54),
    player_speed =  money_display:new(upgrades.upgrade_cannon:price(),29,37),
}

local upgradeq = love.graphics.newQuad(0,33,3,8,64,64)
local upgradeb = love.graphics.newQuad(4,33,3,8,64,64)

local function  drawUpgrades(name,x,y)

    if not (gamestate.upgrades[name] and gamestate.upgrades[name].level >= upgrades[name].maxLevel) then
        mdis[name]:draw()
    end

    for i = 1,upgrades[name].maxLevel do
        love.graphics.draw(button_atlas,upgradeq,x-2*i,y)
    end
    if gamestate.upgrades[name] then
        for i = 1,gamestate.upgrades[name].level do
            love.graphics.draw(button_atlas,upgradeb,x-2*i,y)
        end
    end

end

function  page:draw()

    love.graphics.print("Habitat",13,3)
    for i,v in ipairs(buttons) do
        v:draw()
    end

    love.graphics.print("Health",38,11)
    drawUpgrades("player_health",49,18)


    love.graphics.print("Speed",42,28)
    drawUpgrades("player_speed",49,35)

    love.graphics.print("Repair Drones",10,45)
    drawUpgrades("player_repair_drones",49,52)

    for i,v in ipairs(upgrade_buttons) do
        v:draw()
    end
end

function  page:update(dt)
    mdis.player_health.n = tostring(upgrades.player_health:price())
    mdis.player_repair_drones.n = tostring(upgrades.player_repair_drones:price())
    mdis.player_speed.n = tostring(upgrades.player_speed:price())
end

function  page:clicked(x,y,b)
    for i,v in ipairs(buttons) do
        v:clicked(x,y,b)
    end

    for i,v in ipairs(upgrade_buttons) do
        v:clicked(x,y,b)
    end

end

function  page:released(x,y,b)
    for i,v in ipairs(buttons) do
        v:released(x,y,b)
    end

    for i,v in ipairs(upgrade_buttons) do
        v:released(x,y,b)
    end
end


return page