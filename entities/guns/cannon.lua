local cannon = require("entities.guns.gun"):extend()
--cannon.head= love.graphics.newImage("graphics/gun_cannon_head.png")
--cannon.barrel = love.graphics.newImage("graphics/gun_cannon_barrel.png")

cannon.sfx = {"laser0","laser1","laser2","laser3","laser4"}
local sfx = require("audio.sfx.sfx")
local gamestate = require("gamestate")
local bullet = require("entities.bullets.bullet")
function cannon:shoot()

    local sfxn = love.math.random(1,#self.sfx)
    sfx.play(cannon.sfx[sfxn])
    local bx,by = self:calcBarrelPos()
    local bullet =  bullet:new(bx,by,self.barrelAngle-math.pi/2)
    gamestate.entities.bullets:insert( bullet)
    self.cooldown = 1/gamestate.stats.cannon_firerate
end

return cannon