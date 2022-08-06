local gamestate = require("gamestate")

local auguments = {
    cannon_firerate = {
        maxLevel = 10,
      --  basenum = guns.firerate,
        price = function (self)
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
}

function  auguments.cannon_firerate.apply(level)
    local b = gamestate.base_stats.cannon_firerate
    for i = 0,level-1 do
        b = b + .9*(auguments.cannon_firerate.maxLevel-i)/(.8*auguments.cannon_firerate.maxLevel)
    end
    gamestate.stats.cannon_firerate = b
    print(level,b)
end

function  auguments.gun_damage.apply(level)
--    for i = 0,level-1 do
  --      bullet.damage = bullet.damage + .3*(auguments.gun_damage.maxLevel-i)/(.75*auguments.gun_damage.maxLevel)
    --end
end

function  auguments.purchase(name)
    if gamestate.upgrades[name] and gamestate.upgrades[name].level+1 > auguments[name].maxLevel then return end
    gamestate.upgrades[name] = gamestate.upgrades[name] or {level = 0}
    gamestate.upgrades[name].level = gamestate.upgrades[name].level + 1
    auguments[name].apply(gamestate.upgrades[name].level)
    return true
end

return auguments

