local asteroid = require("entities.entity"):extend()
asteroid.sprite = require("graphics.sprites").asteroid
asteroid.type = "asteroid"
asteroid.damage = 1
asteroid.w = 7
asteroid.h = 6
asteroid.collidewithplayer = true
asteroid.money = 25

function asteroid:new(speed)
    local x,y = asteroid:getRandomSpawn()
    return setmetatable({
        x = x,
        y = y,
        health = 2,
        vx = 0,
        vy = speed,
    },self)
end


function  asteroid:update(dt)
    self.y = self.y + dt*self.vy
    self.x = self.x + dt*self.vx
    if self.y > 64 then self.isDead = true end
end


local explosion = require("graphics.animations.explosion")
local animation = require("util.animation")
local gamestate = require("gamestate")
function  asteroid:die(payout)
    if payout then
        gamestate.player.money = gamestate.player.money + asteroid.money
    end
    animation.startDetached(explosion:create(),self.x,self.y)
    
    self.isDead = true
end


function  asteroid:draw()
    
    love.graphics.draw(self.sprite,self.x,self.y)
  --  love.graphics.rectangle("line",self.x,self.y,self.w,self.h)
end


return asteroid