local animation = require("util.animation")
local esp = require("graphics.sprites").explosion
local iw,ih = esp:getDimensions()
local nq = love.graphics.newQuad
local explosion = animation:new(esp,
{nq(0,0,10,10,iw,ih),nq(11,0,10,10,iw,ih),nq(22,0,10,10,iw,ih),
nq(33,0,10,10,iw,ih),nq(44,0,10,10,iw,ih),nq(55,0,10,10,iw,ih),},
{
    {d=.05,quadId = 1,ox = 0,oy = 0,r = 0,sx = 1,sy = 1},
    {d=.07,quadId = 2,ox = 0,oy = 0,r = 0,sx = 1,sy = 1},
    {d=.08,quadId = 3,ox = 0,oy = 0,r = 0,sx = 1,sy = 1},
    {d=.11,quadId = 4,ox = 0,oy = 0,r = 0,sx = 1,sy = 1},
    {d=.13,quadId = 5,ox = 0,oy = 0,r = 0,sx = 1,sy = 1},
    {d=.14,quadId = 6,ox = 0,oy = 0,r = 0,sx = 1,sy = 1},
}
)


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



return explosion