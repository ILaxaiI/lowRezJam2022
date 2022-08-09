local shield = require("entities.entity"):extend()
shield.__index = shield
shield.type = "bullet"
shield.sprite = require("graphics.sprites").energy_shield
shield.line = {x1=0,y1=1,x2=11,y2=1}
shield.hp = 12


function shield:new(x,y,angle)
    return setmetatable({
        x = x,
        y = y,
        health = 12,
        hybernate = false,
        damage = 1,
        angle = angle},self)
end


function  shield:setA(a)
    self.angle = a
end
local gamestate = require("gamestate")

local overlap = require("util.overlap")
local vec2 = require("util.vec2")
function  shield:update(dt) 
    if not self.hybernate then

    local lx,ly = vec2.rotate(self.line.x2,self.line.y2,self.angle)
        for i,ent in ipairs(gamestate.entities.entities) do
            if ent.type == "radiation" and not ent.isDead and 
            (overlap.lineAABB(
                self.x - lx/2,self.y - ly/2,self.x+lx/2,self.y+lx/2,
                ent.x,ent.y,ent.w,ent.h)
            or overlap.lineAABB(
                self.x + lx/2,self.y + ly/2,self.x-lx/2,self.y-lx/2,
                ent.x,ent.y,ent.w,ent.h)) then
 
                ent:takeDamage(10*self.damage*dt)
                self.health = self.health - 8 *dt
                if self.health <= 0 then break end
            end
        end

        if self.health <= 0 then
            self.parent.cooldown = self.parent.cd
            self:die()
        end
    else
        self.health = math.min(self.hp,self.health + 3*dt)
    end
end

function  shield:draw()
    if not self.hybernate then
        love.graphics.setColor(1,1,1,self.health/10)
        love.graphics.draw(self.sprite,self.x,self.y,self.angle,1,1,5.5,1.5)
        love.graphics.setColor(1,1,1,1)
    end

end




return shield