local gmst = {}
gmst.__index = gmst

local gamestate = setmetatable({},gmst)


local entityMt = {}
entityMt.__index = entityMt


function  entityMt:remove(ent)
    if not ent then return false end
    local id = ent.id
    self[id] = self[#self]
    self[id].id = id
    self[#self] = nil
end
function entityMt:insert(ent)
    if not ent then return false end
    local id = #self+1
    self[id] = ent
    ent.id = id
end


function gmst.default()
    gamestate.difficulty = 1
    gamestate.player = {
        passive_income = 10,
        money = 10000,
        health = 20,
        maxHealth = 10,
        guns = {},
        entity = nil -- = require("entities.habitat").new(),
    }
    gamestate.entities = {
        habitat = setmetatable({},entityMt),
        entities = setmetatable({},entityMt),
        bullets = setmetatable({},entityMt)
    }
    gamestate.base_stats = {
        cannon_damage = 1,
        cannon_firerate = 3
    }
    gamestate.guns = {
        [0] =nil
    }
    gamestate.stats = {}

    gamestate.currentLevel = 0
    gamestate.currentSection = 1
    gamestate.progressFlags = {}
    for i,v in pairs(gamestate.base_stats) do
        gamestate.stats[i] = v
    end
  

    gamestate.upgrades = {}
end




function  gmst:save()
    
end

function  gmst:load()
    
end

gmst.default()

return gamestate