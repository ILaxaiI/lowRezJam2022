local solarflare = require("entities.entity"):extend()
solarflare.sprite = require("graphics.sprites").solar_flare

local nq = love.graphics.newQuad
local iw,ih = solarflare.sprite:getDimensions()

local animation = require("util.animation")

solarflare.warningAnim = animation.new(
    solarflare.sprite,
    {[0] = nq(0,11,10,10,iw,ih),nq(11,11,10,10,iw,ih),nq(22,11,10,10,iw,ih),
    nq(33,11,10,10,iw,ih),nq(44,11,10,10,iw,ih),nq(44,11,10,10,iw,ih)},
    {
    {d = .05,quadId = 0,ox = 0,oy = 5,r = 0,sx = 1,sy =1},
    {d = .05,quadId = 1,ox = 0,oy = 5,r = 0,sx = 1,sy = 1},
    {d = .05,quadId = 2,ox = 0,oy = 5,r = 0,sx = 1,sy = 1},
    {d = .05,quadId = 3,ox = 0,oy = 5,r = 0,sx = 1,sy = 1},
    {d = .05,quadId = 4,ox = 0,oy = 5,r = 0,sx = 1,sy = 1},
    {d = .05,quadId = 3,ox = 0,oy = 5,r = 0,sx = 1,sy = 1},
    {d = .05,quadId = 2,ox = 0,oy = 5,r = 0,sx = 1,sy = 1},
    {d = .05,quadId = 1,ox = 0,oy = 5,r = 0,sx = 1,sy = 1}
    }
)

solarflare.warningAnim:setCallback("onEnd",function (anim,self)
    self.shootAnim:start()
    self.playing = self.shootAnim
end)

solarflare.shootAnim = animation.new(
    solarflare.sprite,
    {[0] = nq(0,0,10,10,iw,ih),nq(11,0,10,10,iw,ih), nq(22,0,10,10,iw,ih),nq(33,0,10,10,iw,ih)},
    {{d = .08, quadId = 0,ox = 0,oy = 0,r = 0,sx = 1,sy = 20},
    {d = .08, quadId = 1,ox = 0,oy = 0,r = 0,sx = 1,sy = 20},
    {d = .08, quadId = 2,ox = 0,oy = 0,r = 0,sx = 1,sy = 20},
    {d = .18, quadId = 3,ox = 0,oy = 0,r = 0,sx = 1,sy = 20},
    {d = .18, quadId = 2,ox = 0,oy = 0,r = 0,sx = 1,sy = 20},
    {d = .18, quadId = 1,ox = 0,oy = 0,r = 0,sx = 1,sy = 20},
    {d = .18, quadId = 0,ox = 0,oy = 0,r = 0,sx = 1,sy = 20}}
)

local boxes = {
    [1] = {ox = 3,oy = 0,w = 4,h= 64},
    [2] = {ox = 2,oy = 0,w = 6,h= 64} ,
    [3] = {ox = 2,oy = 0,w = 6,h= 64} ,
    [4] = {ox = 2,oy = 0,w = 6,h= 64},
    [5] = {ox = 2,oy = 0,w = 6,h= 64},
    [6] = {ox = 2,oy = 0,w = 6,h= 64} ,
    [7] = {ox = 3,oy = 0,w = 4,h= 64},

}

solarflare.collidewithplayer = false


solarflare.shootAnim:setCallback("onStart",function (anim,self)
    self.collidewithplayer = true
end)
solarflare.shootAnim:setCallback("onFrame",function (anim,self,frame)
    self.aabbxo = boxes[frame].ox
    self.aabbyo = boxes[frame].ox
    self.w = boxes[frame].w
    self.h = boxes[frame].h
end)
solarflare.shootAnim:setCallback("onEnd",function (anim,self,frame)
    self:die()
end)

local rnd = love.math.random
solarflare.damage =1
solarflare.spawnRegions = {{5,-5,25,-5},{40,-5,51,-5}}
function  solarflare.new(warnings)

    local regions = solarflare.spawnRegions
    local spawnRegion = regions[rnd(1,#regions)]
    local x,y = rnd(spawnRegion[1],spawnRegion[3]),rnd(spawnRegion[2],spawnRegion[4])
    local fl = {
        x = x,
        y = y,
        warningAnim = solarflare.warningAnim:create(),
        shootAnim = solarflare.shootAnim:create()
    }

    fl.warningAnim:start()
    fl.playing = fl.warningAnim
    fl.warningAnim:setLoop(warnings)
    fl.warningAnim.args = {onEnd = fl}
    fl.shootAnim.args = {onFrame = fl,onStart = fl,onEnd = fl}
    return setmetatable(fl,solarflare)
end


local gamestate = require("gamestate")
function solarflare:impactPlayer(dt) 
    gamestate.player.health = gamestate.player.health - self.damage*dt
end


function  solarflare:update(dt)
    self.playing:update(dt)
end


function  solarflare:draw()
    self.playing:draw(self.x,self.y)
end


return solarflare