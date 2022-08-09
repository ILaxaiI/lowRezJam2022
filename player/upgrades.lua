local gamestate = require("gamestate")

local gunSpawns = {3,14,44,55}
local upgrades = {
    cannon_firerate = {
        maxLevel = 10,
      --  basenum = guns.firerate,
        price = function (self)
            if not gamestate.upgrades["cannon_firerate"] then gamestate.upgrades["cannon_firerate"] = {level = 0} end
            return ((gamestate.upgrades["cannon_firerate"].level or 0)+1) * 100
        end
    },
    gun_damage = {

        maxLevel = 10,
     --   basenum = bullet.damage,
        price = function (self)
            return ((gamestate.upgrades["gun_damage"] and gamestate.upgrades["gun_damage"].level or 0)+1) * 100
        end
    },

    purchase_cannon = {
        maxLevel = 1,
        price = function () return 100 end
    },
    purchase_energy_shield = {
        maxLevel = 1,
        price = function () return 1000 end
    }






}

local gb = require("entities.gunbase")
function upgrades.purchase_cannon.apply(level)
    if not gamestate.progressFlags.cannon_purchased then
    gamestate.progressFlags.cannon_purchased = true

    gamestate.guns[0]= gb:new(gunSpawns[1])
    gamestate.guns[0]:attach(require("entities.guns.cannon"):new())
    gamestate.guns[0]:select()
    end
end
function  upgrades.purchase_energy_shield.apply()
    gamestate.guns[1]= gb:new(gunSpawns[2])
    gamestate.guns[1]:attach(require("entities.guns.energy_shield"):new())
end

function  upgrades.cannon_firerate.apply(level)
    local b = gamestate.base_stats.cannon_firerate
    for i = 0,level-1 do
        b = b + .9*(upgrades.cannon_firerate.maxLevel-i)/(.8*upgrades.cannon_firerate.maxLevel)
    end
    gamestate.stats.cannon_firerate = b

end

function  upgrades.gun_damage.apply(level)
--    for i = 0,level-1 do
  --      bullet.damage = bullet.damage + .3*(upgrades.gun_damage.maxLevel-i)/(.75*upgrades.gun_damage.maxLevel)
    --end
end
local amt = {}
amt.__index = amt

function  amt.purchase(name)
    
    if gamestate.upgrades[name] and gamestate.upgrades[name].level+1 > upgrades[name].maxLevel then return end
    if not upgrades[name] then return end

    local price = upgrades[name].price and upgrades[name]:price()
    if price and price <= gamestate.player.money then
        gamestate.player.money = gamestate.player.money - price
    else
        return false
    end
    
    gamestate.upgrades[name] = gamestate.upgrades[name] or {level = 0}
    gamestate.upgrades[name].level = gamestate.upgrades[name].level + 1
    upgrades[name].apply(gamestate.upgrades[name].level)
    return true
end
setmetatable(upgrades,amt)
return upgrades

