local gamestate = require("gamestate")

local gunSpawns = {3,30,--44,
55}
local upgrades = {
    cannon_firerate = {
        maxLevel = 10,
        price = function (self)
            if not gamestate.upgrades["cannon_firerate"] then gamestate.upgrades["cannon_firerate"] = {level = 0} end
            return ((gamestate.upgrades["cannon_firerate"].level or 0)+1) * 100
        end
    },
    cannon_damage = {
        maxLevel = 10,
        price = function (self)
            return ((gamestate.upgrades["cannon_damage"] and gamestate.upgrades["cannon_damage"].level or 0)+1) * 100
        end
    },

    purchase_cannon = {
        maxLevel = 1,
        price = function () return 100 end
    },

    upgrade_cannon = {
        maxLevel = 1,
        price = function () return 5000 end
    },





    purchase_energy_shield = {
        maxLevel = 1,
        price = function () return 500 end
    },
    energy_shield_health = {
        maxLevel = 10,
        price = function (self)
           return ((gamestate.upgrades["energy_shield_health"] and gamestate.upgrades["energy_shield_health"].level or 0)+1) * 150
        end
    },
    energy_shield_recharge = {
        maxLevel = 10,
        price = function (self)
           return ((gamestate.upgrades["energy_shield_recharge"] and gamestate.upgrades["energy_shield_recharge"].level or 0)+1) * 100
        end
    },





    purchase_antimatter_cannon = {
        maxLevel = 1,
        price = function () return 4000 end
    },
    antimatter_explosion_size = {
        maxLevel = 10,
        price = function () return 1250 + ((gamestate.upgrades["antimatter_explosion_size"] and gamestate.upgrades["antimatter_explosion_size"].level or 0)+1) * 350 end
    },
    antimatter_explosion_damage = {
        maxLevel = 10,
        price = function () return 1000 + ((gamestate.upgrades["antimatter_explosion_damage"] and gamestate.upgrades["antimatter_explosion_damage"].level or 0)+1) * 250 end
    },




    player_health = {
        maxLevel = 10,
        price = function () return 250 + ((gamestate.upgrades["antimatter_explosion_damage"] and gamestate.upgrades["player_health"].level or 0)+1) * 100 end
    },
    player_repair_drones = {
        maxLevel = 5,
        price = function () return 1000 + ((gamestate.upgrades["antimatter_explosion_damage"] and gamestate.upgrades["player_repair_drones"].level or 0)+1) * 1000 end
    },
    player_speed = {
        maxLevel = 10,
        price = function () return 50 + ((gamestate.upgrades["antimatter_explosion_damage"] and gamestate.upgrades["player_speed"].level or 0)+1) * 70 end
    }

}

local gb = require("entities.guns.gunbase")
function upgrades.purchase_cannon.apply(level)
    if not gamestate.progressFlags.cannon_purchased then
    gamestate.progressFlags.cannon_purchased = true

    gamestate.guns[0] = gb:new(gunSpawns[1])
    gamestate.guns[0]:attach(require("entities.guns.cannon"):new())
    if gamestate.guns[0]:select() then gamestate.selectedWeapon = 0 end
    end
end

function upgrades.upgrade_cannon.apply()
    if not (gamestate.guns[0] and gamestate.guns[0].weapon) then
         gamestate.guns[0] = gb:new(gunSpawns[1])
    end
    gamestate.guns[0]:attach(require("entities.guns.cannon2shot"):new())
    gamestate.guns[0].spawning = true
    gamestate.guns[0].spawnT = 0
    if gamestate.guns[0]:select() then gamestate.selectedWeapon = 0 end
end


function upgrades.purchase_energy_shield.apply()
    if not gamestate.progressFlags.purchase_energy_shield then
    gamestate.progressFlags.purchase_energy_shield = true
    gamestate.guns[1]= gb:new(gunSpawns[2])
    gamestate.guns[1]:attach(require("entities.guns.energy_shield"):new())
    if gamestate.guns[1]:select() then gamestate.selectedWeapon = 1 end
    end
end

function upgrades.purchase_antimatter_cannon.apply()
    if not gamestate.progressFlags.purchase_antimatter_cannon then
    gamestate.progressFlags.purchase_antimatter_cannon = true
    gamestate.guns[2]= gb:new(gunSpawns[3])
    gamestate.guns[2]:attach(require("entities.guns.antimatter_cannon"):new())
    if gamestate.guns[2]:select() then gamestate.selectedWeapon = 2 end
    end
end


function  upgrades.energy_shield_health.apply(level)
    gamestate.stats.energy_shield_health = gamestate.base_stats.energy_shield_health + 2*level
end
function  upgrades.energy_shield_recharge.apply(level)
    gamestate.stats.energy_shield_recharge = gamestate.base_stats.energy_shield_recharge + .2*level
end





function upgrades.cannon_firerate.apply(level)
    local b = gamestate.base_stats.cannon_firerate
    for i = 0,level-1 do
        b = b + .9*(upgrades.cannon_firerate.maxLevel-i)/(.8*upgrades.cannon_firerate.maxLevel)
    end
    gamestate.stats.cannon_firerate = b

end

function  upgrades.cannon_damage.apply(level)
    local b = gamestate.base_stats.cannon_damage
    gamestate.stats.cannon_damage = b+.5*level
end



function  upgrades.antimatter_explosion_size.apply(level)
    local b = gamestate.base_stats.antimatter_explosion_size
    gamestate.stats.antimatter_explosion_size = b+.1*level
end
function  upgrades.antimatter_explosion_damage.apply(level)
    local b = gamestate.base_stats.antimatter_explosion_damage
    gamestate.stats.antimatter_explosion_damage = b+1*level
end



function  upgrades.player_health.apply(level)
    local b = gamestate.player.maxHealth
    gamestate.player.maxHealth = gamestate.player.base_maxHealth+3*level
    gamestate.player.health = gamestate.player.health + (gamestate.player.maxHealth - b)
end
function  upgrades.player_repair_drones.apply(level)
    gamestate.stats.player_regen = level*.2
end
function  upgrades.player_speed.apply(level)
    gamestate.stats.player_speed = gamestate.base_stats.player_speed + 2*level
end



local amt = {}
amt.__index = amt

function  amt.purchase(name,pay)
    
    if gamestate.upgrades[name] and gamestate.upgrades[name].level+1 > upgrades[name].maxLevel then return end
    if not upgrades[name] then return end

    if not pay then
        local price = upgrades[name].price and upgrades[name]:price()
        if price and price <= gamestate.player.money then
            gamestate.player.money = gamestate.player.money - price
        else
            return false
        end
    end
    gamestate.upgrades[name] = gamestate.upgrades[name] or {level = 0}
    gamestate.upgrades[name].level = gamestate.upgrades[name].level + 1
    upgrades[name].apply(gamestate.upgrades[name].level)
    return true
end
setmetatable(upgrades,amt)
return upgrades

