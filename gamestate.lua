local gmst = {}
gmst.__index = gmst

local gamestate = {}


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
        health = 10,
        maxHealth = 10,
        guns = {}
    }
    gamestate.entities = {
        habitat = setmetatable({},entityMt),
        entities = setmetatable({},entityMt),
        bullets = setmetatable({},entityMt)
    }
    gamestate.upgrades = {}
    return setmetatable(gamestate,gmst)
end




function  gmst:save()
    
end

function  gmst:load()
    
end

gmst.default()

return gamestate