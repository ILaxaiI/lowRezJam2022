local beam = require("entities.entity"):extend()
beam.sprite = require("graphics.sprites").ship_atlas

local q = love.graphics.newQuad
local iw,ih = beam.sprite:getDimensions()

local animation = require("util.animation")
beam.timescale = 1
beam.warningAnim = animation:new(beam.sprite,
{q(51,0,4,3,iw,ih),q(57,0,4,3,iw,ih),q(63,0,4,3,iw,ih)
,q(69,0,4,3,iw,ih),q(75,0,6,3,iw,ih),q(83,0,8,3,iw,ih)
},
{
    {d = .33,quadId = 1,ox = 0,oy = 0,r = 0,sx = 1,sy =1,orx = 2, ory = 0},
    {d = .33,quadId = 2,ox = 0,oy = 0,r = 0,sx = 1,sy =1,orx = 2, ory = 0},
    {d = .33,quadId = 3,ox = 0,oy = 0,r = 0,sx = 1,sy =1,orx = 2, ory = 0},
    {d = .12,quadId = 4,ox = 0,oy = 0,r = 0,sx = 1,sy =1,orx = 2, ory = 0},
    {d = .2,quadId = 5,ox = 0,oy = 0,r = 0,sx = 1,sy =1,orx = 3, ory = 0},
    {d = .3,quadId = 6,ox = 0,oy = 0,r = 0,sx = 1,sy =1,orx = 4, ory = 0},
})

beam.warningAnim:setCallback("onFrame",function (anim,self,frame)
    if frame == 4 then
        self.shootAnim:start()
        self.shootAnim.timer = 0
        self.playing = true
    end
    if self.playing then
        self.shootAnim.currentFrame = frame - 3
    end
end)

beam.shootAnim = animation:new(
    beam.sprite,
    {q(68,5,6,6,iw,ih),q(75,5,6,6,iw,ih),q(84,5,6,6,iw,ih)},
    {{d = .5, quadId = 1,ox = 0,oy = 0,r = 0,sx = 1,sy = 20,orx = 3,ory =-3/20},
    {d = .2, quadId = 2,ox = 0,oy = 0,r = 0,sx = 1,sy = 20,orx = 3,ory = -3/20},
    {d = .3, quadId = 3,ox = 0,oy = 0,r = 0,sx = 1,sy = 20,orx = 3,ory = -3/20}}
)



beam.collidewithplayer = false


beam.shootAnim:setCallback("onStart",function (anim,self)
    self.collidewithplayer = true
end)
beam.shootAnim:setCallback("onEnd",function (anim,self,frame)
    self:die()
end)


beam.damage = 7
function  beam:new(x,y,r)
    local fl = {
        x = x,
        y = y,
        r = r,
        warningAnim = beam.warningAnim:create(),
        shootAnim = beam.shootAnim:create()
    }

    fl.warningAnim.args = {onFrame = fl,onStart = fl,onEnd = fl}
    fl.warningAnim:start()
    fl.playing = false
 
    fl.shootAnim.args = {onFrame = fl,onStart = fl,onEnd = fl}
    return setmetatable(fl,self)
end 


local gamestate = require("gamestate")
function beam:impactPlayer(dt) 
    gamestate.player.health = gamestate.player.health - self.damage*dt
end


function  beam:update(dt)
    self.warningAnim:update(beam.timescale*dt)
    
    if self.playing then
        self.shootAnim:update(beam.timescale *dt)
    end
end
local overlap = require("util.overlap")
function  beam.overlap(e1,e2)
    local x1 = e1.x + (e1.aabbxo or 0)
    local y1 = e1.y + (e1.aabbyo or 0)
    
    local r = e2.r + math.pi/2
    local x2 = e2.x + math.cos(r) * 100
    local y2 = e2.y + math.sin(r) * 100
    return overlap.lineAABB(e2.x,e2.y,x2,y2,  x1,y1,e1.w,e1.h)
end

function  beam:draw()
    self.warningAnim:draw2(self.x,self.y,self.r)
    if self.playing then
        self.shootAnim:draw2(self.x,self.y,self.r)
    end
end


return beam