local antimatter_explosion = require("entities.entity"):extend()
antimatter_explosion.__index = antimatter_explosion
antimatter_explosion.speed =50
antimatter_explosion.type = "bullet"
antimatter_explosion.damage = 10
antimatter_explosion.bw = 20
antimatter_explosion.bh = 20
antimatter_explosion.w = 20
antimatter_explosion.h = 20

antimatter_explosion.size =1
antimatter_explosion.aabbxo = 0
antimatter_explosion.aabbyo = 0


antimatter_explosion.explosionSize=9

antimatter_explosion.anim = require("graphics.animations.large_explosion")

local gamestate = require("gamestate")
antimatter_explosion.anim:setCallback("onEnd",function (anim,self)
    self.isDead = true
end)
antimatter_explosion.anim:setCallback("onFrame",function (...)
    local anim,self,frame = ...
 
    self.w = anim.frames[frame].S*self.size
    self.h = anim.frames[frame].S*self.size
    self.aabbxo = (self.bw*self.size - self.w)/2
    self.aabbyo = (self.bh*self.size - self.h)/2
    self.explosionSize = self.w/2
end
)


function antimatter_explosion:new(x,y)
    local b = setmetatable({
        x = x - antimatter_explosion.bw*gamestate.stats.antimatter_explosion_size/2,
        y = y- antimatter_explosion.bh*gamestate.stats.antimatter_explosion_size/2,
        animation = antimatter_explosion.anim:create(),
        vx = 0,vy = 0,
        damage = gamestate.stats.antimatter_explosion_damage,
        size = gamestate.stats.antimatter_explosion_size
    },self)
    b.animation.args = {onEnd = b,onFrame = b}
    b.animation:start()
    return b
end



local overlap = require("util.overlap")
function  antimatter_explosion:update(dt)
    self.animation:update(dt)
    
    for i,ent in ipairs(gamestate.entities.entities) do
        if (ent.type == "asteroid" or ent.type == "ship") and not ent.isDead and
            ent.overlap(self,ent) then
            ent:takeDamage(self.damage*dt,self)
        end
    end
end

function  antimatter_explosion:draw()
    self.animation:draw(self.x,self.y,self.size)
end



function antimatter_explosion:die()
    self.isDead = true
end


return antimatter_explosion