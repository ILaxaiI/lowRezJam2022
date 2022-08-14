local cannon = require("entities.guns.gun"):extend()
--cannon.head= love.graphics.newImage("graphics/gun_cannon_head.png")
--cannon.barrel = love.graphics.newImage("graphics/gun_cannon_barrel.png")


cannon.sfx = {"laser0","laser1","laser2","laser3","laser4"}
local sfx = require("audio.sfx.sfx")

cannon.barrel = require("graphics.sprites").antimatter_barrel
cannon.barrelOffsetX = 2.5
cannon.barrelOffsetY = -1.5

cannon.barrelWidth = cannon.barrel:getWidth()
cannon.barrelHeight = cannon.barrel:getHeight()
local gamestate = require("gamestate")
local bullet = require("entities.bullets.antimatter_bullet")
function cannon:shoot()

    local sfxn = love.math.random(1,#self.sfx)
    sfx.play(cannon.sfx[sfxn])
    local bx,by = self:calcBarrelPos()
    local bullet =  bullet:new(bx,by,self.barrelAngle-math.pi/2)
    gamestate.entities.bullets:insert( bullet)
    self.cooldown = 2.1
end

return cannon