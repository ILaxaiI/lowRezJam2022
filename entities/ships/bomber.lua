local bomber = require("entities.entity"):extend()
bomber.sprite = require("graphics.sprites").ship_atlas
bomber.quad = love.graphics.newQuad(29,7,10,11,bomber.sprite:getDimensions())
bomber.w = 10
bomber.h = 11
bomber.type ="ship"
bomber.firerate = 0.5
bomber.money = 130
local nq = love.graphics.newQuad
local animation = require("util.animation")
local iw,ih = bomber.sprite:getDimensions()
bomber.thrusterAnim = animation:new(
    bomber.sprite,
    {nq(31,0,6,2,iw,ih),nq(31,4,6,2,iw,ih)},
    {
        {d=.2,quadId = 1,ox = 2,oy =-1,r = 0,sx = 1,sy = 1},
        {d=.2,quadId = 2,ox = 2,oy = -1,r = 0,sx = 1,sy = 1},
    }
)
bomber.thrusterAnim:start()
bomber.thrusterAnim:setLoop(true)
function bomber:new()
    local x,y = bomber:getRandomSpawn()
    return setmetatable({
        x = x,
        y = y,
        health = 3,
        vx = 0,
        vy = 16,
        firecd = 1,
        spawning = true,
        anim = bomber.thrusterAnim:create(),
        height = love.math.random(3,8),
        ai = {},

        lifetime = 0
    },self)
end

local gamestate = require("gamestate")
local bullet = require("entities.bullets.rockets")

function  bomber:update(dt)
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
        gamestate.entities.entities:insert(bullet:new(self.x+5,self.y+6,math.pi/2))
        self.firecd = 0
    end


    if self.y > 64 then self.isDead = true end
end

function  bomber:draw()
    self.anim:draw(self.x,self.y)
    love.graphics.draw(self.sprite,self.quad,self.x,self.y)
end
local explosion = require("graphics.animations.explosion")
bomber.sfx = {
    love.audio.newSource("audio/sfx/explosion.wav","static"),
    love.audio.newSource("audio/sfx/8bit_bomb_explosion.wav","static"),
}
bomber.sfx[1]:setVolume(.3)
bomber.sfx[2]:setVolume(.3)
function  bomber:die(payout)
    if payout then
        gamestate.player.money = gamestate.player.money + bomber.money
    end
    animation.startDetached(explosion:create(),self.x,self.y)

    self.isDead = true
end


return bomber