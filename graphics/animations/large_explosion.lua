local animation = require("util.animation")
local esp = require("graphics.sprites").explosion
local iw,ih = esp:getDimensions()
local nq = love.graphics.newQuad
local explosion = animation:new(esp,
{nq(1,31,18,18,iw,ih),nq(21,31,18,18,iw,ih),nq(41,31,18,18,iw,ih),nq(1,51,18,18,iw,ih),nq(21,51,18,18,iw,ih),nq(40,50,20,20,iw,ih)},
{
    {d=.07,quadId = 1,ox = 0,oy = 0,r = 0,sx = 1,sy = 1,S = 4},
    {d=.09,quadId = 2,ox = 0,oy = 0,r = 0,sx = 1,sy = 1,S = 10},
    {d=.11,quadId = 3,ox = 0,oy = 0,r = 0,sx = 1,sy = 1, S = 14},
    {d=.13,quadId = 4,ox = 0,oy = 0,r = 0,sx = 1,sy = 1, S = 18},
    {d=.14,quadId = 5,ox = 0,oy = 0,r = 0,sx = 1,sy = 1, S = 18},
    {d=.11,quadId = 6,ox = -1,oy = -1,r = 0,sx = 1,sy = 1, S = 20},
})



explosion.sfx = {
    love.audio.newSource("audio/sfx/explosion.wav","static"),
    love.audio.newSource("audio/sfx/8bit_bomb_explosion.wav","static"),
}
explosion.sfx[1]:setVolume(.3)
explosion.sfx[2]:setVolume(.3)

function  explosion:start()
    self.timer = 0
    self.currentFrame = 1
    self:call("onStart")
    self:call("onFrame",1)
    self.playing = true
    local sfx = love.math.random(1,2)
    explosion.sfx[sfx]:stop()
    explosion.sfx[sfx]:setPitch((love.math.random()-.2) + .8)
    explosion.sfx[sfx]:play()
end


function explosion:draw(x,y,s)
    if self.playing then
        local frame = self.frames[self.currentFrame]
        love.graphics.draw(self.sprite,self.quads[frame.quadId],frame.ox+x+self.ox,frame.oy+y+self.oy,frame.r,frame.sx*s,frame.sy*s)
    end
end


return explosion