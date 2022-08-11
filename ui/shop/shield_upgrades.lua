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

local unlock = button:new(
    require("graphics.sprites").play_button,
    {love.graphics.newQuad(0,102,42,14,128,128),love.graphics.newQuad(43,102,42,41,128,128)},
    10,30,42,14,upgrades.purchase,"purchase_energy_shield"
)
local unlock_price = money_display:new(upgrades.purchase_energy_shield:price(),32,46,false)

local upgrade_buttons = {
    button:new(
        button_atlas,
        {love.graphics.newQuad(22,0,10,10,64,64),love.graphics.newQuad(33,0,10,10,64,64)},
        51,19,10,10,upgrades.purchase,"energy_shield_health"
    ),
    button:new(
        button_atlas,
        {love.graphics.newQuad(22,0,10,10,64,64),love.graphics.newQuad(33,0,10,10,64,64)},
        51,34,10,10,upgrades.purchase,"energy_shield_recharge"
    ),
    --[[
    button:new(
        button_atlas,
        {love.graphics.newQuad(22,0,10,10,64,64),love.graphics.newQuad(33,0,10,10,64,64)},
        51,51,10,10,upgrades.purchase,"upgrade_cannon"
    ),]]
}

local upgradeq = love.graphics.newQuad(0,33,3,8,64,64)
local upgradeb = love.graphics.newQuad(4,33,3,8,64,64)
function  page:draw()

    love.graphics.print("Shield",13,3)
    for i,v in ipairs(buttons) do
        v:draw()
    end
    if not gamestate.progressFlags.purchase_energy_shield then
         unlock:draw()
         unlock_price:draw()
    else

        love.graphics.print("Shield Health",11,13)
        for i = 1,upgrades.energy_shield_health.maxLevel do
            love.graphics.draw(button_atlas,upgradeq,49-2*i,20)
        end
        if gamestate.upgrades.energy_shield_health then
            for i = 1,gamestate.upgrades.energy_shield_health.level do
                love.graphics.draw(button_atlas,upgradeb,49-2*i,20)
            end
        end

        love.graphics.print("Recharge Rate",11,29)

        for i = 1,upgrades.energy_shield_recharge.maxLevel do
            love.graphics.draw(button_atlas,upgradeq,49-2*i,36)
        end
        if gamestate.upgrades.energy_shield_recharge then
            for i = 1,gamestate.upgrades.energy_shield_recharge.level do
                love.graphics.draw(button_atlas,upgradeb,49-2*i,36)
            end
        end

        --[[

        love.graphics.print("Double Barrel",10,45)
        for i = 1,upgrades.upgrade_cannon.maxLevel do
            love.graphics.draw(button_atlas,upgradeq,49-2*i,52)
        end
        if gamestate.upgrades.upgrade_cannon then
            for i = 1,gamestate.upgrades.upgrade_cannon.level do
                love.graphics.draw(button_atlas,upgradeb,49-2*i,52)
            end
        end
]]
        for i,v in ipairs(upgrade_buttons) do
            v:draw()
        end
    end
end

function  page:update(dt)
end

function  page:clicked(x,y,b)
    for i,v in ipairs(buttons) do
        v:clicked(x,y,b)
    end
    if not gamestate.progressFlags.purchase_energy_shield then
        unlock:clicked(x,y,b)
    else
        for i,v in ipairs(upgrade_buttons) do
            v:clicked(x,y,b)
        end
    end
end

function  page:released(x,y,b)
    for i,v in ipairs(buttons) do
        v:released(x,y,b)
    end
    if not gamestate.progressFlags.purchase_energy_shield then
        unlock:released(x,y,b)
    else
        for i,v in ipairs(upgrade_buttons) do
            v:released(x,y,b)
        end
    end
end


return page