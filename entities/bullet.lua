local bullet = require("entities.entity"):extend()
bullet.__index = bullet
bullet.speed =70
bullet.type = "bullet"
bullet.damage = 1
bullet.w =1
bullet.h = 1

function bullet.new(x,y,angle)
    return setmetatable({
        x = x,
        y = y,
        vx = bullet.speed*math.cos(angle),
        vy = bullet.speed*math.sin(angle)
    },bullet)
end



local gamestate = require("gamestate")
local overlap = require("util.overlap")
function  bullet:update(dt)

    self.x = self.x + self.vx*dt
    self.y = self.y + self.vy*dt
    if self.x > 100 or self.x < -100 or self.y < -100 or self.y > 100 then
        gamestate.entities.bullets:remove(self)
    end

    for i,ent in ipairs(gamestate.entities.entities) do
        if ent.type == "asteroid" and not ent.isDead and
            overlap.aabb(self.x,self.y,self.w,self.h,ent.x,ent.y,ent.w,ent.h) then
            ent:takeDamage(self.damage)
            self:die()
            break
        end
    end
end

function  bullet:draw()
    love.graphics.setColor(1,1,0)
    love.graphics.rectangle("fill",self.x,self.y,1,1)
    love.graphics.setColor(1,1,1)
end


local explosion = require("graphics.animations.smallexplosion")
local animation = require("util.animation")

function bullet:die()
    animation.startDetached(explosion:create(),self.x-2,self.y-2)
    self.isDead = true
end


return bullet