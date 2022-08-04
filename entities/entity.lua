local entity = {}
entity.__index = entity

entity.damage = 0

function  entity:extend()
    local e = {health = 0}
    e.__index = e
    return setmetatable(e,entity)
end

function  entity:die()
    self.isDead = true
end

entity.spawnRegions = {{0,-5,60,-5}}

local gamestate = require("gamestate")
-- Called only if player collides with the object
function  entity:impactPlayer()
    self:die()
    gamestate.player.health = gamestate.player.health - self.damage
end

function entity:takeDamage(dmg)
    self.health = self.health - dmg
    if self.health <= 0 then self:die() end
end

function  entity.update() end
function  entity.draw() end
return entity