local animation = require("util.animation")
local esp = require("graphics.sprites").explosion
local iw,ih = esp:getDimensions()
local nq = love.graphics.newQuad
local explosion = animation.new(esp,
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

return explosion