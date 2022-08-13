local animation = require("util.animation")
local esp = require("graphics.sprites").explosion
local iw,ih = esp:getDimensions()
local nq = love.graphics.newQuad
local explosion = animation:new(esp,
{nq(0,20,10,10,iw,ih),nq(11,20,10,10,iw,ih),nq(22,20,10,10,iw,ih),
nq(33,20,10,10,iw,ih),nq(44,20,10,10,iw,ih),nq(55,20,10,10,iw,ih),},
{
    {d=.05,quadId = 1,ox = 0,oy = 0,r = 0,sx = 1,sy = 1},
    {d=.07,quadId = 2,ox = 0,oy = 0,r = 0,sx = 1,sy = 1},
    {d=.08,quadId = 3,ox = 0,oy = 0,r = 0,sx = 1,sy = 1},
    {d=.11,quadId = 4,ox = 0,oy = 0,r = 0,sx = 1,sy = 1},
    {d=.13,quadId = 5,ox = 0,oy = 0,r = 0,sx = 1,sy = 1},
    {d=.14,quadId = 6,ox = 0,oy = 0,r = 0,sx = 1,sy = 1},
}
)


explosion.r = 0


local sfx = require("audio.sfx.sfx")
local s = {"explosion1","explosion2"}

function  explosion:create()
    return setmetatable({r = love.math.random(1,4)/2*math.pi},self)
end

function  explosion:start()
    self.timer = 0
    self.currentFrame = 1
    self:call("onStart")
    self:call("onFrame",1)
    self.playing = true
    
    sfx.play(s[love.math.random(1,2)],(love.math.random()-.2) + .8)
end

function explosion:draw(x,y)
    if self.playing then
        local frame = self.frames[self.currentFrame]
        love.graphics.draw(self.sprite,self.quads[frame.quadId],frame.ox+x+self.ox, frame.oy+y+self.oy, self.r+frame.r,frame.sx,frame.sy,5,5)
    end
end


return explosion