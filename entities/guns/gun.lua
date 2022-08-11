local gun = {}
gun.__index = gun
gun.head= require("graphics.sprites").gun_cannon_head
gun.barrel = require("graphics.sprites").gun_cannon_barrel

gun.barrelOffsetX = 2.5
gun.barrelOffsetY = -1.5
gun.barrelWidth = gun.barrel:getWidth()
gun.barrelHeight = gun.barrel:getHeight()

function gun:extend()
    local g = {}
    g.__index = g
    return setmetatable(g,self)
end

function gun:new()
    return setmetatable({
        barrelAngle = 0,
        cooldown = 0,
        isSelected = false,
    },self)
end
local viewport = require("ui.viewport")

function gun:updateAngle(dt)

    local mx,my = love.mouse.getPosition()
    local scale = viewport.getScale()
    local offsetx,offsety = viewport.getOffset()

    mx = mx/scale - offsetx
    my = my/scale - offsety
    local x,y = self.parent.x+self.barrelOffsetX,self.parent.y+self.barrelOffsetY

    local target = (math.atan2((y-my),(x-mx)))-math.pi/2
    self.barrelAngle = target

end


local vec2 = require("util.vec2")
function  gun:calcBarrelPos()
    if self.parent then
        local x,y = self.parent.x,self.parent.y
        local ba = self.barrelAngle+math.pi

        local ox,oy = vec2.rotate(0,self.barrelHeight,ba)

        return x +self.barrelOffsetX+ox,y+self.barrelOffsetY+oy
    end
    return 0,0
end


function  gun:update(dt)
    self.cooldown = self.cooldown - dt
    if self.isSelected then
      self:updateAngle(dt)
    end
end

function  gun:draw()
    love.graphics.draw(self.head,0,-4)
    love.graphics.draw(self.barrel,self.barrelOffsetX,self.barrelOffsetY,self.barrelAngle,1,1,self.barrelWidth/2,self.barrelHeight-.5)
    
end

local gamestate = require("gamestate")
local bullet = require("entities.bullets.bullet")

function gun:shoot()
    local bx,by = self:calcBarrelPos()
    local bullet =  bullet:new(bx,by,self.barrelAngle-math.pi/2)
    gamestate.entities.bullets:insert( bullet)
    self.cooldown = 1/gamestate.stats.cannon_firerate
end
function  gun:mouseDown()
    if self.cooldown < 0 then
        self:shoot()
    end
end
function  gun:mouseReleased() end



function  gun:switchOff()
    
end

return gun