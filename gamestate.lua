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

local state = require("util.state")
local shopMt = {}
shopMt.__index = shopMt

function  shopMt:setPage(p)
    self.pageHistory[#self.pageHistory+1] = self.currentPage
    self.currentPage = p
end

function shopMt:reset()
    self.pageHistory = {}
    self.currentPage = 1
end

function  shopMt:back()
    self.currentPage = table.remove(self.pageHistory)
    
    if not self.currentPage then
        self.currentPage = 1
        state.set("game")
    end
end

function gmst.default()
    
    gamestate.difficulty = 1
    gamestate.selectedWeapon = 0
    gamestate.player = gamestate.player or {}
    gamestate.player.passive_income = 0
    gamestate.player.money = 1000000
    gamestate.player.health = 20
    gamestate.player.maxHealth = 20
    gamestate.player.base_maxHealth=20
    gamestate.player.guns = {}
    gamestate.player.entity = nil -- = require("entities.habitat").new(),

        gamestate.entities = {
        habitat = setmetatable({},entityMt),
        entities = setmetatable({},entityMt),
        bullets = setmetatable({},entityMt)
    }
    gamestate.base_stats = {
        cannon_damage = 1,
        cannon_firerate = 3,
        energy_shield_health = 12,
        energy_shield_recharge = 3,
        antimatter_explosion_size = 1,
        antimatter_explosion_damage = 7,
        player_speed = 15,
        player_regen = 0,
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
    gamestate.shop = gamestate.shop or setmetatable({},shopMt)

    gamestate.shop.currentPage = 1
    gamestate.shop.pageHistory = {}

 
    gamestate.upgrades = {}
end




function  gmst:save()
    
end

function  gmst:load()
    
end

gmst.default()

return gamestate