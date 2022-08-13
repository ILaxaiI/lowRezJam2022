local green_laser = require("entities.entity"):extend()
green_laser.__index = green_laser
green_laser.speed = 50
green_laser.type = "bullet_laser"
green_laser.damage = 1
green_laser.health = .1
green_laser.aabbxo = 1
green_laser.w = 1
green_laser.h = 5
green_laser.explosionSize = 2
green_laser.collidewithplayer = true

green_laser.sprite = require("graphics.sprites").ship_atlas

local nq = love.graphics.newQuad
local iw,ih = green_laser.sprite:getDimensions()
local animation = require("util.animation")
green_laser.anim = animation:new(green_laser.sprite,
{nq(21,0,3,5,iw,ih),nq(21,6,3,5,iw,ih),nq(21,13,3,5,iw,ih)},
{
    {d=.1,quadId = 1,ox = 0,oy = 0,r = 0,sx = 1,sy = 1},
    {d=.1,quadId = 2,ox = 0,oy = 0,r = 0,sx = 1,sy = 1},
    {d=.1,quadId = 3,ox = 0,oy = 0,r = 0,sx = 1,sy = 1},
    {d=.1,quadId = 2,ox = 0,oy = 0,r = 0,sx = 1,sy = 1},
}
)
green_laser.anim:start()
green_laser.anim:setLoop(true)
function green_laser:new(x,y,angle)
    local gl = {
        x = x,
        y = y,
        angle = angle,
        vx = green_laser.speed*math.cos(angle),
        vy = green_laser.speed*math.sin(angle),
        animation = green_laser.anim:create()
    }
--    gl.animation:start()
    return setmetatable(gl,self)
end

local gamestate = require("gamestate")
local overlap = require("util.overlap")

function  green_laser:update(dt)
    self.animation:update(dt)
    self.x = self.x + self.vx*dt
    self.y = self.y + self.vy*dt
    if self.x > 100 or self.x < -100 or self.y < -5 or self.y > 100 then
        self.isDead = true
    end


end

function  green_laser:draw()
    self.animation:draw(self.x,self.y,self.angle-math.pi/2)
end


local explosion = require("graphics.animations.smallexplosion")
local animation = require("util.animation")

function green_laser:die()

    animation.startDetached(explosion:create(),self.x,self.y+1)
    self.isDead = true
end


return green_laser