local antimatter_bullet = require("entities.entity"):extend()

antimatter_bullet.sprite = love.graphics.newImage("graphics/antimatter_round.png")
antimatter_bullet.__index = antimatter_bullet
antimatter_bullet.speed =70
antimatter_bullet.type = "bullet"
antimatter_bullet.damage = 1
antimatter_bullet.w = 2
antimatter_bullet.h = 2
antimatter_bullet.explosionSize = 2
function antimatter_bullet:new(x,y,angle)
    return setmetatable({
        x = x,
        y = y,
        vx = antimatter_bullet.speed*math.cos(angle),
        vy = antimatter_bullet.speed*math.sin(angle)
    },self)
end



local gamestate = require("gamestate")
local overlap = require("util.overlap")
function  antimatter_bullet:update(dt)

    self.x = self.x + self.vx*dt
    self.y = self.y + self.vy*dt
    if self.x > 100 or self.x < -100 or self.y < -5 or self.y > 100 then
        gamestate.entities.bullets:remove(self)
    end

    for i,ent in ipairs(gamestate.entities.entities) do
        if (ent.type == "asteroid" or ent.type == "ship") and not ent.isDead and
            ent.overlap(self,ent) then
            ent:takeDamage(self.damage,self)
            self:die()
            break
        end
    end
end

function  antimatter_bullet:draw()
    love.graphics.draw(antimatter_bullet.sprite,self.x,self.y)
end


local explosion = require("entities.bullets.antimatter_explosion")

function antimatter_bullet:die()
    gamestate.entities.bullets:insert(explosion:new(self.x,self.y))
    self.isDead = true
end


return antimatter_bullet