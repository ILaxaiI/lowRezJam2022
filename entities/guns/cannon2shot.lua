local cannon2 = require("entities.guns.cannon"):extend()
local vec2 = require("util.vec2")



local viewport = require("ui.viewport")
cannon2.head = require("graphics/sprites").cannon_head_2

function  cannon2:calcBarrelPos()
    if self.parent then
        local x,y = self.parent.x,self.parent.y
        local ox1,oy1 = vec2.rotate(-1,self.barrelHeight,self.barrelAngle+math.pi)
        local ox2,oy2 = vec2.rotate(1,self.barrelHeight,self.barrelAngle+math.pi)
        
        return x +self.barrelOffsetX+ox1,y+self.barrelOffsetY+oy1,x +self.barrelOffsetX+ox2,y+self.barrelOffsetY+oy2
    end
    return 0,0,0,0
end

function  cannon2:draw()
    love.graphics.draw(self.head,0,-4)
    love.graphics.draw(self.barrel,self.barrelOffsetX-1,self.barrelOffsetY,self.barrelAngle,1,1,self.barrelWidth/2,self.barrelHeight-.5)
    love.graphics.draw(self.barrel,self.barrelOffsetX+1,self.barrelOffsetY,self.barrelAngle,1,1,self.barrelWidth/2,self.barrelHeight-.5)
    
end

local gamestate = require("gamestate")
local bullet = require("entities.bullet")
function cannon2:shoot()

    local sfx = love.math.random(1,#self.sfx)
    self.sfx[sfx]:stop()
    self.sfx[sfx]:play()

    local bx1,by1,bx2,by2 = self:calcBarrelPos()
    gamestate.entities.bullets:insert(bullet:new(bx1,by1,self.barrelAngle-math.pi/2))
    gamestate.entities.bullets:insert(bullet:new(bx2,by2,self.barrelAngle-math.pi/2))
    self.cooldown =1.2/ gamestate.stats.cannon_firerate
end


return cannon2