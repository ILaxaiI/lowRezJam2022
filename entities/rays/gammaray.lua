local gammaray = require("entities.entity"):extend()
gammaray.sprite = require("graphics.sprites").gamma_ray_burst

local nq = love.graphics.newQuad
local iw,ih = gammaray.sprite:getDimensions()

local animation = require("util.animation")

gammaray.warningAnim = animation:new(
    gammaray.sprite,
    {[0] = nq(0,11,10,10,iw,ih),nq(11,11,10,10,iw,ih),nq(22,11,10,10,iw,ih),
    nq(33,11,10,10,iw,ih),nq(44,11,10,10,iw,ih),nq(44,11,10,10,iw,ih)},
    {
    {d = .05,quadId = 0,ox = 7,oy = 5,r = 0,sx = 1,sy =1},
    {d = .05,quadId = 1,ox = 7,oy = 5,r = 0,sx = 1,sy = 1},
    {d = .05,quadId = 2,ox = 7,oy = 5,r = 0,sx = 1,sy = 1},
    {d = .05,quadId = 3,ox = 7,oy = 5,r = 0,sx = 1,sy = 1},
    {d = .05,quadId = 4,ox = 7,oy = 5,r = 0,sx = 1,sy = 1},
    {d = .05,quadId = 3,ox = 7,oy = 5,r = 0,sx = 1,sy = 1},
    {d = .05,quadId = 2,ox = 7,oy = 5,r = 0,sx = 1,sy = 1},
    {d = .05,quadId = 1,ox = 7,oy = 5,r = 0,sx = 1,sy = 1}
    }
)
gammaray.warningAnim:setLoop(4)
gammaray.warningAnim:setCallback("onEnd",function (anim,self)
    self.shootAnim:start()
    self.playing = self.shootAnim
end)

gammaray.shootAnim = animation:new(
    gammaray.sprite,
    {[0] = nq(0,0,22,10,iw,ih),nq(22,0,22,10,iw,ih), nq(44,0,22,10,iw,ih),nq(66,0,22,10,iw,ih)},
    {{d = .10, quadId = 0,ox = 0,oy = 0,r = 0,sx = 1,sy = 20},
    {d = .08, quadId = 1,ox = 0,oy = 0,r = 0,sx = 1,sy = 20},
    {d = .08, quadId = 2,ox = 0,oy = 0,r = 0,sx = 1,sy = 20},
    {d = .45, quadId = 3,ox = 0,oy = 0,r = 0,sx = 1,sy = 20},
    {d = .15, quadId = 2,ox = 0,oy = 0,r = 0,sx = 1,sy = 20},
    {d = .13, quadId = 1,ox = 0,oy = 0,r = 0,sx = 1,sy = 20},
    {d = .2, quadId = 0,ox = 0,oy = 0,r = 0,sx = 1,sy = 20}}
)

local boxes = {
    [1] = {ox = 10,oy = 0,w = 4,h= 64},
    [2] = {ox = 8,oy = 0,w = 8,h= 64} ,
    [3] = {ox = 5,oy = 0,w = 14,h= 64} ,
    [4] = {ox = 3,oy = 0,w = 16,h= 64},
    [5] = {ox = 5,oy = 0,w = 14,h= 64},
    [6] = {ox = 8,oy = 0,w = 8,h= 64} ,
    [7] = {ox = 10,oy = 0,w = 4,h= 64},

}

gammaray.collidewithplayer = false


gammaray.shootAnim:setCallback("onStart",function (anim,self)
    self.collidewithplayer = true
end)
gammaray.shootAnim:setCallback("onFrame",function (anim,self,frame)
    self.aabbxo = boxes[frame].ox
    self.aabbyo = boxes[frame].ox
    self.w = boxes[frame].w
    self.h = boxes[frame].h
end)
gammaray.shootAnim:setCallback("onEnd",function (anim,self,frame)
    self:die()
end)


gammaray.damage = 5
gammaray.spawnRegions = {{5,-5,15,-5},{55,-5,59,-5}}
function  gammaray:new()

    local x,y = gammaray:getRandomSpawn()
    local fl = {
        x = x,
        y = y,
        warningAnim = gammaray.warningAnim:create(),
        shootAnim = gammaray.shootAnim:create()
    }

    fl.warningAnim:start()
    fl.playing = fl.warningAnim
 
    fl.warningAnim.args = {onEnd = fl}
    fl.shootAnim.args = {onFrame = fl,onStart = fl,onEnd = fl}
    return setmetatable(fl,self)
end 


local gamestate = require("gamestate")
function gammaray:impactPlayer(dt) 
    gamestate.player.health = gamestate.player.health - self.damage*dt
end


function  gammaray:update(dt)
    self.playing:update(dt)
end


function  gammaray:draw()
    self.playing:draw(self.x,self.y)
   
end


return gammaray