local rocket = require("entities.entity"):extend()
rocket.__index = rocket
rocket.speed =3
rocket.type = "ship"
rocket.damage = 4
rocket.health = .1
rocket.w = 3
rocket.h = 5
rocket.explosionSize = 2
rocket.collidewithplayer = true

rocket.sprite = require("graphics.sprites").ship_atlas

local nq = love.graphics.newQuad
local iw,ih = rocket.sprite:getDimensions()
local animation = require("util.animation")
rocket.anim = animation:new(rocket.sprite,
{nq(43,2,3,5,iw,ih),nq(43,9,3,5,iw,ih)},
{
    {d=.1,quadId = 1,ox = 0,oy = 0,r = 0,sx = 1,sy = 1},
    {d=.3,quadId = 2,ox = 0,oy = 0,r = 0,sx = 1,sy = 1},
}
)
rocket.anim:start()
rocket.anim:setLoop(true)
function rocket:new(x,y,angle)
    local gl = {
        x = x,
        y = y,
        vx = rocket.speed*math.cos(angle),
        vy = rocket.speed*math.sin(angle),
        animation = rocket.anim:create()
    }
--    gl.animation:start()
    return setmetatable(gl,self)
end

local gamestate = require("gamestate")
local overlap = require("util.overlap")

function  rocket:update(dt)
    self.animation:update(dt)
    self.vy = self.vy + 15*dt
    self.x = self.x + self.vx*dt
    self.y = self.y + self.vy*dt
    if self.x > 100 or self.x < -100 or self.y < -5 or self.y > 100 then
        self.isDead = true
    end


end

function  rocket:draw()
    self.animation:draw(self.x,self.y)

end


local explosion = require("graphics.animations.blue_explosion")
local animation = require("util.animation")

function rocket:die()
    animation.startDetached(explosion:create(),self.x,self.y+1)
    self.isDead = true
end


return rocket