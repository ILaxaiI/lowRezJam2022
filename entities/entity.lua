local entity = {}
entity.__index = entity

entity.damage = 0

function  entity:extend()
    local e = {health = 0}
    e.__index = e
    return setmetatable(e,self)
end

local gamestate = require("gamestate")
function  entity:die(payout)
    if payout and self.money then gamestate.player.money = gamestate.player.money + self.money end
    self.isDead = true
end

local rnd = love.math.random
function entity:getRandomSpawn()
    local regions = self.spawnRegions
    local spawnRegion = regions[rnd(1,#regions)]
    return rnd(spawnRegion[1],spawnRegion[3]),rnd(spawnRegion[2],spawnRegion[4])
end

entity.spawnRegions = {{0,-5,60,-5}}

-- Called only if player collides with the object
function  entity:impactPlayer()
    self:die()
    gamestate.player.health = gamestate.player.health - self.damage
end

function entity:takeDamage(dmg)
    self.health = self.health - dmg
    if self.health <= 0 then  self:die(true) end
end

local overlap = require("util.overlap")
function  entity.overlap(e1,e2)
    local x1 = e1.x + (e1.aabbxo or 0)
    local y1 = e1.y + (e1.aabbyo or 0)
    local x2 = e2.x + (e2.aabbxo or 0)
    local y2 = e2.y + (e2.aabbyo or 0)

    return overlap.aabb(x1,y1,e1.w,e1.h,x2,y2,e2.w,e2.h)
end

function  entity:drawHitbox()
    if self.w and self.h then
        love.graphics.setColor(1,1,1,.5)
    local x = self.x + (self.aabbxo or 0)
    local y = self.y + (self.aabbyo or 0)
    
    love.graphics.rectangle("line",math.floor(x)+.5,math.floor(y)+.5,self.w,self.h)

    love.graphics.setColor(1,1,1)
    end
end

function  entity.update() end
function  entity.draw() end
return entity