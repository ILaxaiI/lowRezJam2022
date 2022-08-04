local gamestate = require("gamestate")

local guns = require("player.guns.cannon")
local bullet = require("entities.bullet")
local auguments = {
    gun_firerate = {
        maxLevel = 10,
        basenum = guns.firerate,
    },
    gun_damage = {

        maxLevel = 10,
        basenum = bullet.damage
    },
}

function  auguments.gun_firerate.apply(level)
    guns.firerate = auguments.gun_firerate.basenum
    for i = 0,level-1 do
        guns.firerate = guns.firerate + 1*(auguments.gun_firerate.maxLevel-i)/(.75*auguments.gun_firerate.maxLevel)
    end
    --print(level,(auguments.gun_firerate.maxLevel-level)/(.6*auguments.gun_firerate.maxLevel),guns.firerate)
end

function  auguments.gun_damage.apply(level)
    bullet.damage = auguments.gun_damage.basenum
    for i = 0,level-1 do
        bullet.damage = bullet.damage + .3*(auguments.gun_damage.maxLevel-i)/(.75*auguments.gun_damage.maxLevel)
    end
    print(level,(auguments.gun_damage.maxLevel-level)/(.6*auguments.gun_damage.maxLevel),guns.firerate)
end

function  auguments.purchase(name)
    if gamestate.upgrades[name] and gamestate.upgrades[name].level+1 > auguments[name].maxLevel then return end
    gamestate.upgrades[name] = gamestate.upgrades[name] or {level = 0}
    gamestate.upgrades[name].level = gamestate.upgrades[name].level + 1
    auguments[name].apply(gamestate.upgrades[name].level)
end

return auguments

