local scout = require("entities.entity"):extend()
scout.sprite = require("graphics.sprites").ship_atlas
scout.quad = love.graphics.newQuad(0,9,13,8,scout.sprite:getDimensions())
scout.w = 13
scout.h = 8
scout.type ="ship"
scout.firerate = 0.7
scout.money = 100
local nq = love.graphics.newQuad
local animation = require("util.animation")
local iw,ih = scout.sprite:getDimensions()
scout.thrusterAnim = animation:new(
    scout.sprite,
    {nq(4,0,5,2,iw,ih),nq(4,4,5,2,iw,ih)},
    {
        {d=.2,quadId = 1,ox = 4,oy =-2,r = 0,sx = 1,sy = 1},
        {d=.2,quadId = 2,ox = 4,oy = -2,r = 0,sx = 1,sy = 1},
    }
)
scout.thrusterAnim:start()
scout.thrusterAnim:setLoop(true)
function scout:new(_,_,h)
    local x,y = scout:getRandomSpawn()
    return setmetatable({
        x = x,
        y = y,
        health = 12,
        vx = 0,
        vy = 16,
        firecd = 0,
        spawning = true,
        anim = scout.thrusterAnim:create(),
        height = h or love.math.random(3,8),
        ai = {},

        lifetime = 0
    },self)
end

local gamestate = require("gamestate")
local bullet = require("entities.bullets.green_laser")

local sfx = {
    love.audio.newSource("audio/sfx/laserLarge_003.ogg","static"),
}


function  scout:update(dt)
    self.anim:update(dt)
    self.lifetime = self.lifetime +dt
    if self.spawning then
        self.y = math.min(self.y + dt*self.vy,self.height)
        if self.y >= self.height then
            self.vy = 0
            self.spawning = false
        end
    else
        if not self.ai.targetX then
            self.ai.targetX = love.math.random(5,59)
        end

        self.vx = self.x > self.ai.targetX and -10 or 10
        
        if self.x >= self.ai.targetX and self.x + self.vx*dt <= self.ai.targetX then
            self.x = self.ai.targetX
            self.ai.targetX = nil
        else    
            self.x = self.x + self.vx*dt
        end
   

        self.y = self.y + dt*self.vy
    end
    

    if not spawning and self.lifetime > 6 then
        self.vy = self.vy + 10*dt
    end

    self.firecd = self.firecd + dt
    if self.firecd > 1/self.firerate then
        gamestate.entities.entities:insert(bullet:new(self.x+5,self.y+4,math.pi/2))
        sfx[1]:stop()
        sfx[1]:setPitch(.3*love.math.random()+.85)
        sfx[1]:play()
        self.firecd = 0
    end


    if self.y > 64 then self.isDead = true end
end

function  scout:draw()
    self.anim:draw(self.x,self.y)
    love.graphics.draw(self.sprite,self.quad,self.x,self.y)
end




local explosion = require("graphics.animations.explosion")
function  scout:die(payout)
    if payout then
        gamestate.player.money = gamestate.player.money + scout.money
    end
    animation.startDetached(explosion:create(),self.x,self.y)

    self.isDead = true
end


return scout