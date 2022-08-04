local cannon = require("player.guns.gun"):extend()
--cannon.head= love.graphics.newImage("graphics/gun_cannon_head.png")
--cannon.barrel = love.graphics.newImage("graphics/gun_cannon_barrel.png")

cannon.sfx = {
    love.audio.newSource("audio/sfx/laserSmall_000.ogg","static"),
    love.audio.newSource("audio/sfx/laserSmall_001.ogg","static"),
    love.audio.newSource("audio/sfx/laserSmall_002.ogg","static"),
    love.audio.newSource("audio/sfx/laserSmall_003.ogg","static"),
    love.audio.newSource("audio/sfx/laserSmall_004.ogg","static"),
}
for i,v in ipairs(cannon.sfx) do
    v:setVolume(.3)
end
cannon.firerate =3
function cannon.new()
    return setmetatable({
        barrelAngle = 0,
        cooldown = 0,
        isSelected = false,
    },cannon)
end

local gamestate = require("gamestate")
local bullet = require("entities.bullet")
function cannon:shoot()

    local sfx = love.math.random(1,#self.sfx)
    self.sfx[sfx]:stop()
    self.sfx[sfx]:play()
    local bx,by = self:calcBarrelPos()
    local bullet =  bullet.new(bx,by,self.barrelAngle-math.pi/2)
    gamestate.entities.bullets:insert( bullet)
    self.cooldown = 1/cannon.firerate
end

return cannon